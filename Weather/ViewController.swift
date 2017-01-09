//
//  ViewController.swift
//  Weather
//
//  Created by MacBook 1 on 06/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit
import Alamofire
import Argo
import Curry
import Runes
import Kingfisher
import CoreLocation
import MapKit

extension User: Decodable {
    static func decode(_ j: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> j <| "cod"
            <*> j <| "message"
            <*> j <| "cnt"
            <*> j <|| "list"
    }
    
}

struct User {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ListWeather]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var weatherListTableView: UITableView!
    
    var user: User?
    var locationManager = CLLocationManager()
    var date = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Weather Forecast"
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast?lat=\(locValue.latitude)&lon=\(locValue.longitude)&appid=8131be7e3e6b2014b3af931e011bd730").responseJSON { response in
            
            let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
            
            if let j: Any = json {
                self.user = decode(j)
            }
            
            self.weatherListTableView.reloadData()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.user != nil{
            return (self.user?.list.count)!
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = weatherListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomWeatherTableViewCell
        
        if self.user != nil{
            
            let list = self.user?.list
            let weather = list?[indexPath.row]
            
            let url = URL(string: "http://openweathermap.org/img/w/\((weather?.weather[0].icon)!).png")
            
            cell.temperatureLbl.text =  String.init(format: "%.1f\u{00B0}", Double((weather?.main.temp)!) - 273.15)
            cell.weatherIcon.kf.indicatorType = .activity
            cell.weatherIcon.kf.setImage(with: url)
            cell.timeLbl.text = weather?.dt_txt
            cell.weatherLbl.text = weather?.weather[0].main
            cell.descriptionLbl.text = weather?.weather[0].description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherDetailVC = storyboard.instantiateViewController(withIdentifier: "WeatherDetailVC") as! WeatherDetailViewController
        weatherDetailVC.weatherList = (self.user?.list[indexPath.row])!
        self.navigationController?.pushViewController(weatherDetailVC, animated: true)
        
    }
}

