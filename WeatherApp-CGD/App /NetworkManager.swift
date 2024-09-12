//
//  WeatherNetworkManager.swift
//  WeatherApp-CGD
//
//  Created by Django on 9/11/24.
//

import Foundation

import Foundation

class WeatherNetworkService {
    
    let baseURL = "https://api.weatherstack.com/current"
    let accessKey = "f10f2a7cf9df0e642f4cc6ff1a0328ad"
    
    let urlSession = URLSession.shared
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping(Result<WeatherResponse, NetworkError>) -> Void) {
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse {
                completion(.failure(.statusCodeError(httpResponse.statusCode)))
            } else {
                completion(.failure(.invalidResponse))
            }
            return
        }
        
        guard let data = data else {
            completion(.failure(.noData))
            return
        }
        
        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(.success(weatherResponse))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    
    func fetchWeatherByLocation(cityName: String, completion: @escaping(Result<WeatherResponse, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "access_key", value: accessKey),
            URLQueryItem(name: "query", value: cityName)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            self.handleResponse(data: data, response: response, error: error) { result in
                completion(result)
            }
        }.resume()
    }
}
