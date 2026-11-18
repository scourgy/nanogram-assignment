//
//  GameFeedViewController.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import UIKit

class GameFeedViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var statusView: GameFeedStatusView!
    @IBOutlet private weak var closeButton: UIButton!
    
    // MARK: - Actions
    @IBAction private func closeTapped(_ sender: UIButton) {
        viewModel.exitPlayMode()
    }
        
    @objc private func feedTapped() {
        viewModel.enterPlayMode()
    }
    
    @objc private func appWillResignActive() {
        gamePlayerController.pause()
    }
        
    @objc private func appDidBecomeActive() {
        gamePlayerController.resume()
    }
    
    // MARK: - Dependencies
    private var viewModel: GameFeedViewModel
    private var gamePlayerController: GamePlayerControllerProtocol
    private var dataSource: GameFeedDataSource
    
    // MARK: - Variables and constants
    private lazy var playModeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(feedTapped))
    private weak var playerCell: GameFeedCell?
    
    // MARK: - Initialization
    init?(coder: NSCoder, viewModel: GameFeedViewModel, gamePlayerController: GamePlayerControllerProtocol, dataSource: GameFeedDataSource) {
        self.viewModel = viewModel
        self.gamePlayerController = gamePlayerController
        self.dataSource = dataSource
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init with coder, viewModel, gamePlayerController and dataSource.")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupStatusView()
        bindViewModel()
        bindGamePlayerController()
        observeAppLifecycle()
        viewModel.start()
    }

    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.register(GameFeedCell.nib, forCellWithReuseIdentifier: GameFeedCell.identifier)
        collectionView.collectionViewLayout = makeFullScreenPagingLayout()
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.addGestureRecognizer(playModeTapRecognizer)
    }
    
    private func observeAppLifecycle() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setupStatusView() {
        statusView.onRetry = { [weak self] in
            self?.viewModel.retry()
        }
    }
    
    private func bindViewModel() {
        viewModel.onItemsChange = { [weak self] in
            self?.insertNewItems()
        }
        viewModel.onPlayModeChange = { [weak self] isPlayMode in
            self?.setPlayMode(isPlayMode)
        }
        viewModel.onGameFeedStateChange = { [weak self] state in
            self?.statusView.setupForGameFeedState(state)
        }
        viewModel.onGameLikeChange = { [weak self] isLiked, index in
            guard let strongSelf = self else { return }
            let game = strongSelf.viewModel.game(at: index)
            let cell = strongSelf.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameFeedCell
            cell?.configure(with: game, isLiked: isLiked)
        }
    }
    
    private func bindGamePlayerController() {
        gamePlayerController.onStateChange = { [weak self] state in
            self?.playerCell?.setGamePlayerState(state)
        }
    }
    
    private func makeFullScreenPagingLayout() -> UICollectionViewLayout {
        let fullScreen = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: fullScreen)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: fullScreen, subitems: [item])
        return UICollectionViewCompositionalLayout(section: NSCollectionLayoutSection(group: group))
    }
    
    private func insertNewItems() {
        let displayedCount = collectionView.numberOfItems(inSection: 0)
        let loadedCount = viewModel.numberOfItems
        
        guard loadedCount != displayedCount else {
            return
        }
        guard loadedCount > displayedCount else {
            collectionView.reloadData()
            return
        }
        
        let indexPaths = (displayedCount..<loadedCount).map { IndexPath(item: $0, section: 0) }
        collectionView.insertItems(at: indexPaths)
    }
    
    private func setPlayMode(_ isPlayMode: Bool) {
        collectionView.isScrollEnabled = !isPlayMode
        playModeTapRecognizer.isEnabled = !isPlayMode
        closeButton.isHidden = !isPlayMode
        gamePlayerController.setInteractive(isPlayMode)
        activeCell?.setPlayMode(isPlayMode)
    }
    
    private var activeCell: GameFeedCell? {
        guard let activeIndex = viewModel.activeIndex else {
            return nil
        }
        return collectionView.cellForItem(at: IndexPath(item: activeIndex, section: 0)) as? GameFeedCell
    }
    
    private func activate(index: Int) {
        guard index != viewModel.activeIndex else {
            return
        }
        viewModel.didActivate(index: index)
        syncPlayer()
    }
    
    private func syncPlayer() {
        guard let activeIndex = viewModel.activeIndex,
                let cell = collectionView.cellForItem(at: IndexPath(item: activeIndex, section: 0)) as? GameFeedCell else {
            gamePlayerController.stop()
            return
        }
        play(at: activeIndex, in: cell)
    }
    
    private func play(at index: Int, in cell: GameFeedCell) {
        playerCell = cell
        cell.onRetry = { [weak self] in
            self?.gamePlayerController.stop()
            self?.syncPlayer()
        }
        gamePlayerController.play(viewModel.game(at: index), in: cell.playerContainer)
    }
    
    private func pageIndex(for contentOffset: CGPoint) -> Int {
        let pageHeight = collectionView.bounds.height
        guard pageHeight > 0, viewModel.numberOfItems > 0 else {
            return 0
        }
        let index = Int((contentOffset.y / pageHeight).rounded())
        return min(max(index, 0), viewModel.numberOfItems - 1)
    }
    
}

// MARK: - UICollectionViewDelegate
extension GameFeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if viewModel.activeIndex == nil {
                // The first page that appears becomes the active one.
                viewModel.didActivate(index: indexPath.item)
            }
            guard indexPath.item == viewModel.activeIndex, let cell = cell as? GameFeedCell else {
                return
            }
            play(at: indexPath.item, in: cell)
        }
        
        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item == viewModel.activeIndex {
                gamePlayerController.stop()
            }
        }
        
        // MARK: - UIScrollViewDelegate
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            activate(index: pageIndex(for: targetContentOffset.pointee))
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                activate(index: pageIndex(for: scrollView.contentOffset))
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            activate(index: pageIndex(for: scrollView.contentOffset))
        }
    
}

