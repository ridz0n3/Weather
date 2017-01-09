//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by MacBook 1 on 08/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherDetailViewController: UIViewController {

    var weatherList: ListWeather?
    
    @IBOutlet weak var weatherImgView: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://openweathermap.org/img/w/\((weatherList?.weather[0].icon)!).png")
        
        weatherImgView.kf.indicatorType = .activity
        weatherImgView.kf.setImage(with: url)
        dateTimeLbl.text = weatherList?.dt_txt
        weatherLbl.text = weatherList?.weather[0].main
        descriptionLbl.text = weatherList?.weather[0].description
        pressureLbl.text = "\((weatherList?.main.pressure)!) hpa"
        humidityLbl.text = "\((weatherList?.main.humidity)!)%"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
