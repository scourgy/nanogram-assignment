//
//  ViewController.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import UIKit

class GameFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testGameDecoding()
    }
    
    private func testGameDecoding() {
        guard let url = Bundle.main.url(
            forResource: "example-response",
            withExtension: "json"
        ) else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(
                GamePageResponse.self,
                from: data
            )

            print("Games count: \(response.games.count)")
            print("Next page: \(String(describing: response.nextPage))")

            if let firstGame = response.games.first {
                print("First game: \(firstGame.title)")
                print("Creator: \(String(describing: firstGame.creator?.username))")
            }

        } catch {
            print("Decoding failed: \(error)")
        }
    }


}

