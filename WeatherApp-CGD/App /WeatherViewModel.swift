//
//  WeatherViewModel.swift
//  WeatherApp-CGD
//
//  Created by Django on 9/11/24.
//

import Foundation

class WeatherViewModel {
    
    var weather: WeatherResponse?
    var errorMessage: String?
    
    private let weatherService = WeatherNetworkService()
    
    func fetchingCurrentWeather(with cityName: String, completion: @escaping () -> Void) {
        weatherService.fetchWeatherByLocation(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                self?.weather = weatherResponse
                self?.errorMessage = nil
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.weather = nil
            }
            
            //MARK: - Here
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
