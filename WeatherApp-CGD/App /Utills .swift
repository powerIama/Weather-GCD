//
//  Utills .swift
//  WeatherApp-CGD
//
//  Created by Django on 9/11/24.
//

import Foundation
import UIKit

enum BackgroundColors {
    case sunny
    case cloudy
    case rainy
    case snowy
    
    var colors: [CGColor] {
        switch self {
        case .sunny:
            return [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        case .cloudy:
            return [UIColor.gray.cgColor, UIColor.white.cgColor]
        case .rainy:
            return [UIColor.black.cgColor, UIColor.white.cgColor]
        case .snowy:
            return [UIColor.white.cgColor, UIColor.black.cgColor]
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case requestFailed(Error)
    case invalidResponse
    case statusCodeError(Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .requestFailed(let error):
            return "The network request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server response was invalid."
        case .statusCodeError(let code):
            return "Received an invalid status code: \(code)"
        }
    }
}
