//
//  WeatherModel.swift
//  WeatherApp-CGD
//
//  Created by Django on 9/11/24.
//

import Foundation

struct WeatherResponse: Codable {
    let request: Request
    let location: Location
    let current: Current
}

struct Request: Codable {
    let type: String
    let query: String
    let language: String
    let unit: String
}

struct Location: Codable {
    let name: String
    let country: String
    let region: String
    let lat: String
    let lon: String
    let timezoneID: String
    let localtime: String
    let localtimeEpoch: Int
    let utcOffset: String

    enum CodingKeys: String, CodingKey {
        case name, country, region, lat, lon
        case timezoneID = "timezone_id"
        case localtime
        case localtimeEpoch = "localtime_epoch"
        case utcOffset = "utc_offset"
    }
}

struct Current: Codable {
    let observationTime: String
    let temperature: Int
    let weatherCode: Int
    let weatherIcons: [String]
    let weatherDescriptions: [String]
    let windSpeed: Int
    let windDegree: Int
    let windDir: String
    let pressure: Int
    let precip: Int
    let humidity: Int
    let cloudcover: Int
    let feelslike: Int
    let uvIndex: Int
    let visibility: Int
    let isDay: String

    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case temperature
        case weatherCode = "weather_code"
        case weatherIcons = "weather_icons"
        case weatherDescriptions = "weather_descriptions"
        case windSpeed = "wind_speed"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressure
        case precip
        case humidity
        case cloudcover
        case feelslike
        case uvIndex = "uv_index"
        case visibility
        case isDay = "is_day"
    }
}
