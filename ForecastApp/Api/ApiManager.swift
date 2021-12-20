//
//  ApiManager.swift
//  ForecastApp
//
//  Created by Tatsiana Marchanka on 7.12.21.
//

import Foundation
import CoreLocation
class apiManager {
    
static let shared = apiManager()

    private let keyApi = "8b6d0d55deb6890bd4e0c8a4a2651356"
func currentWeatherWithCity(geo: String, complition: @escaping (Result<WeatherResultInfo, Error>) -> Void) {
       let city = geo
        let citySearch = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(keyApi)"
        print(city)
        print(citySearch)
        let url = URL(string: citySearch)
        
        guard let url = url else {
            return
        }
      URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error")
                return
            }
            do {
              let result =  try JSONDecoder().decode(WeatherResultInfo.self, from: data)
              complition(.success(result))
                
             
            } catch  {
                print(error)
               complition(.failure(error))
            }
        }.resume()
    }
    

    func currentWeatherWithLocation(coordinates: String, complition: @escaping (Result<WeatherResultInfo, Error>) -> Void) {
        print(coordinates)
        let url = URL(string: coordinates)
        
        guard let url = url else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error")
                return
            }
            do {
              let result =  try JSONDecoder().decode(WeatherResultInfo.self, from: data)
              complition(.success(result))
                
             
            } catch  {
                print(error)
               complition(.failure(error))
            }
        }.resume()
    
    }
    
        func fullForecastWithLocation(coordinates: String, complition: @escaping (Result<[ForecastI], Error>) -> Void) {
        print(coordinates)
        let url = URL(string: coordinates)
        
        guard let url = url else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error")
                return
            }
            do {
              let result =  try JSONDecoder().decode(FullForecastModel.self, from: data)
                complition(.success(result.list))
                
            } catch  {
                print(error)
               complition(.failure(error))
            }
        }.resume()
    
    }
    
    func fullForecastWithCity(geo: String, complition: @escaping (Result<[ForecastI], Error>) -> Void) {
           let city = geo
            let citySearch = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(keyApi)"
//    https://api.openweathermap.org/data/2.5/forecast?q=Minsk&appid=8b6d0d55deb6890bd4e0c8a4a2651356
        print(city)
            print(citySearch)
            let url = URL(string: citySearch)
            
            guard let url = url else {
                return
            }
          URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("error")
                    return
                }
                do {
                  let result =  try JSONDecoder().decode(FullForecastModel.self, from: data)
                    complition(.success(result.list))
                    
                 
                } catch  {
                    print(error)
                   complition(.failure(error))
                }
            }.resume()
        }
    
}
