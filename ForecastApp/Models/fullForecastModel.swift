//
//  fullForecastModel.swift
//  ForecastApp
//
//  Created by Tatsiana Marchanka on 8.12.21.
//

import Foundation

struct FullForecastModel: Codable {
        let city: City
        let list: [ForecastI]
    }

    struct City: Codable {
        let name: String
        let sunrise: Int
        let sunset: Int
    }

    struct ForecastI: Codable {
        let main: MainI
        let weather: [WeatherI]
        let dt_txt: String
    }

    struct MainI: Codable {
        let temp: Double
        let feels_like: Double
    }

    struct WeatherI: Codable {
        let description: String
        let icon: String
    }

  
