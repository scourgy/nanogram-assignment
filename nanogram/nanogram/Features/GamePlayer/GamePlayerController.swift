//
//  GamePlayController.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

import UIKit
import WebKit

protocol GamePlayerControllerProtocol {
    
    func play(_ game: Game, in container: UIView)
    func stop()
    func pause()
    func resume()
    func setInteractive(_ isInteractive: Bool)
    var onStateChange:((_ state: GamePlayerState) -> Void)? { get set }
    
}

class GamePlayerController: NSObject, GamePlayerControllerProtocol {
    
    // MARK: - Variables and constants
    private var webView: WKWebView?
    private var currentGame: Game?
    private var isInteractive = false
    
    private let configuration: WKWebViewConfiguration = {
            let configuration = WKWebViewConfiguration()
            configuration.websiteDataStore = .default()
            configuration.allowsInlineMediaPlayback = true
            configuration.mediaTypesRequiringUserActionForPlayback = []
            return configuration
        }()
    
    // MARK: - Callbacks:
    var onStateChange: ((GamePlayerState) -> Void)?
    
    // MARK: - Setup
    func play(_ game: Game, in container: UIView) {
        if currentGame?.id == game.id, let webView, webView.superview === container {
            return
        }
        stop()
        
        let webView = WKWebView(frame: container.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isUserInteractionEnabled = isInteractive
        container.addSubview(webView)

        self.webView = webView
        currentGame = game
        load(game)
    }
    
    func stop() {
        webView?.stopLoading()
        webView?.navigationDelegate = nil
        webView?.removeFromSuperview()
        webView = nil
        currentGame = nil
    }
    
    func pause() {
        webView?.setAllMediaPlaybackSuspended(true)
    }
    
    func resume() {
        webView?.setAllMediaPlaybackSuspended(false)
    }
    
    func setInteractive(_ isInteractive: Bool) {
        self.isInteractive = isInteractive
        webView?.isUserInteractionEnabled = isInteractive
    }
    
    // MARK: - Private
    private func load(_ game: Game) {
        onStateChange?(.loading)
         webView?.loadHTMLString(game.html, baseURL: URL(string: "https://\(game.id).games.nanogram.local/"))
    }
    
    private func handleError(_ error: Error) {
        onStateChange?(.failed)
    }
    
}

// MARK: - WKNavigationDelegate
extension GamePlayerController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        // Sub-frames may load what they want
        // the main frame may only ever show our game.
        guard navigationAction.targetFrame?.isMainFrame == true else {
            return .allow
        }
        guard let url = navigationAction.request.url else {
            return .cancel
        }
        let isGameOrigin = url.scheme == "about" || url.host?.hasSuffix("games.nanogram.local") == true
        return isGameOrigin ? .allow : .cancel
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onStateChange?(.running)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        handleError(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        handleError(error)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        if let currentGame {
            load(currentGame)
        }
    }
}
