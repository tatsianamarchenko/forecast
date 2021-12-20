//
//  ViewController.swift
//  ForecastApp
//
//  Created by Tatsiana Marchanka on 7.12.21.
//

import UIKit
import CoreLocation

class NowViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var feelsLikeLable: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var sunsetLable: UILabel!
    @IBOutlet weak var sunriseLable: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var model = [Model]()

    
    let location : CLLocationManager = CLLocationManager()
    var coordinates : CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBackground()
        table.register(ForecastTableViewCell.nub(), forCellReuseIdentifier: ForecastTableViewCell.identifier)
        setLocation()
        table.delegate = self
        table.dataSource = self
        table.reloadData()
     //   createProgress(progressView: progressLine)
    }
    
    func createProgress(progressView: UIProgressView) {
        progressView.setProgress(0.0, animated: true)
        let observe = Progress()
        progressView.observedProgress = observe
    }
    
    func setLocation (){
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestAlwaysAuthorization()
        location.startUpdatingLocation()
        location.delegate = self
    }
    
    @IBAction func updateLocation(_ sender: Any) {
       setLocation()
        print("lol")
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let vc = UIAlertController(title: "enter city", message: "find weather", preferredStyle: .alert)
        let findAction = UIAlertAction(title: "find", style: .default) { _ in
            guard let cityName = vc.textFields?.first?.text, cityName != "" else {
                return
            }
            apiManager.shared.currentWeatherWithCity(geo: cityName) {result in
                switch result {
                case .success(let forecast):
                    DispatchQueue.main.async {
                        self.updateUI(model: forecast)
                    }
                   
                    print(forecast.name)
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            apiManager.shared.fullForecastWithCity(geo: cityName) { [weak self] result in
                switch result {
                case .success(let forecast):
                    self?.forecast = forecast
                    self?.model = forecast.compactMap({ Model(weatherdate: $0.dt_txt, weatherMax: String("\(self!.convertTemperature(temp: $0.main.temp))℃"), weatherMin: String("feels like: \(self!.convertTemperature(temp: $0.main.feels_like))℃"))})
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        vc.addTextField(configurationHandler: nil)
        vc.addAction(findAction)
        vc.addAction(cancelAction)
        present(vc, animated: true)
    }
    var forecast = [ForecastI]()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location!)
        location.stopUpdatingLocation()
        coordinates = locations.last! as CLLocation
        let currentCoordinates =  reciveLocation(whichUI: "mainUi")
        apiManager.shared.currentWeatherWithLocation(coordinates: currentCoordinates) { result in
            switch result {
            case .success(let forecast):
                print(forecast.name)
                DispatchQueue.main.async {
                    self.updateUI(model: forecast)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        let currentCoordinatesAdditional =  reciveLocation(whichUI: "additionalUi")
        apiManager.shared.fullForecastWithLocation(coordinates: currentCoordinatesAdditional) { [weak self] result in
            switch result {
            case .success(let forecastq):
                self?.forecast = forecastq
                print("что то получила")
                self?.model = forecastq.compactMap({ Model(weatherdate: $0.dt_txt, weatherMax: String("\(self!.convertTemperature(temp: $0.main.temp))℃"), weatherMin: String("feels like: \(self!.convertTemperature(temp: $0.main.feels_like))℃"))})
                    
                DispatchQueue.main.async {
                    self?.table.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func  reciveLocation(whichUI: String) -> String {
        guard let coordinates = coordinates else {
            print("error")
            return ""
        }
        let lon = coordinates.coordinate.longitude
        let lat = coordinates.coordinate.latitude
        print(lon, lat)
        let keyApi = "8b6d0d55deb6890bd4e0c8a4a2651356"
        var result = ""
        if whichUI == "mainUi" { result = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(keyApi)" }
        print(result)
        if whichUI == "additionalUi" { result = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(keyApi)"}
        print(result)
        return result
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateUI(model: WeatherResultInfo){
        
        cityLable.text = model.name
        temperatureLable.text = String("\(convertTemperature(temp:  model.main.temp))℃")
        feelsLikeLable.text = String("feels like: \(convertTemperature(temp: model.main.feelsLike))℃")
        weatherDescription.text = String(model.weather[0].main)
        sunsetLable.text = convertTime(time: model.sys.sunset)
        sunriseLable.text = convertTime(time: model.sys.sunrise)
    }
    
    func convertTime(time: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        let dateCurrent = Int(Date().timeIntervalSince1970)
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
  
    func convertTemperature(temp: Double) -> Double  {
        let temperature = temp - 273.15
        let result = Double(round(1000*temperature)/1000)
        return result
    }
    
    func changeBackground() {
        let homepageDay = UIImage(named: "day")
        let homepageNight = UIImage(named: "night")
        let hour =  Calendar.current.component(.hour, from: Date())
        switch hour
        {
        case 1...5, 19...24: backgroundImage.image = homepageNight
            tabBarController?.tabBar.backgroundColor = UIColor(red: 60/255.0, green: 122/255.0, blue: 200/255.0, alpha: 0.8)
            
            view.backgroundColor = UIColor(red: 105/255.0, green: 166/255.0, blue: 250/255.0, alpha: 1.0)
        case 6...18: backgroundImage.image = homepageDay
            tabBarController?.tabBar.backgroundColor = UIColor(red: 68/255.0, green: 222/255.0, blue: 211/255.0, alpha: 1.0)
            view.backgroundColor = UIColor(red: 105/255.0, green: 250/255.0, blue: 228/255.0, alpha: 1.0)
        default:
            backgroundImage.backgroundColor = .cyan
        }
        
    }
}

extension NowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
    cell.configure(with: model)
    return cell
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

class Model  {
    var weatherdate : String
    var weatherMax : String
    var weatherMin : String
    init (weatherdate : String, weatherMax : String, weatherMin : String) {
        self.weatherdate = weatherdate
        self.weatherMax = weatherMax
        self.weatherMin = weatherMin
    }
    }
