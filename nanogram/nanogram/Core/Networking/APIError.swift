//
//  APIError.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidPage(page: Int)
    case httpError(statusCode: Int)
    case network
    case decoding
    case cancelled
    case unknown(String)
    
    var userMessage: String {
        switch self {
            case .network: "A network error occurred. Please try again."
            case .httpError, .invalidResponse: "The server returned an error. Please try again."
            case .decoding: "The feed could not be read."
            case .cancelled: ""
            case .invalidPage, .unknown: "Something went wrong. Please try again."
        }
    }

    static func map(_ error: Error) -> APIError {
        if let apiError = error as? APIError {
            return apiError
        }

        if let urlError = error as? URLError {
            if urlError.code == .cancelled {
                return .cancelled
            }

            return .network
        }

        if error is DecodingError {
            return .decoding
        }

        if error is CancellationError {
            return .cancelled
        }

        return .unknown(error.localizedDescription)
    }
}
