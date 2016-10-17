//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 13.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var degreeLabel : UILabel!
    @IBOutlet weak var celsiusLabel : UILabel!
    @IBOutlet weak var cityLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var detailsLabel : UILabel!
    @IBOutlet weak var windLabel : UILabel!
    @IBOutlet weak var lastUpdatedTime: UILabel!
    @IBOutlet weak var blurImage : UIImageView!
    var timer : Timer!
    var formatter : DateFormatter!
    var lastUpdatedFormatter : DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter = DateFormatter()
        lastUpdatedFormatter = DateFormatter()
        lastUpdatedFormatter.dateFormat = "EEEE dd MMMM, HH:mm:ss"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCurrentDate), userInfo: nil, repeats: true)
         self.updateDisplayData(DataManager.sharedInstance.loadWeatherData())
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationUpdated(_:)),
            name: NSNotification.Name(rawValue: "DidUpdateLocation"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(errorFetchLocation),
            name: NSNotification.Name(rawValue: "LocationPermissionError"),
            object: nil)
        
        LocationManager.sharedInstance.startUpdatingUserLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func updateCurrentDate() -> Void {

        formatter.dateFormat = "EEEE dd MMMM"
        self.dateLabel.text = formatter.string(from: Date()).firstLetterCapitalizedString()
        
        formatter.dateFormat = "HH:mm:ss"
        self.timeLabel.text = formatter.string(from: Date())
    }

    func errorFetchLocation() -> Void {
        self.loadWeatherData(nil)
    }
    
    func locationUpdated(_ notif:Notification?) -> Void {
        if (notif != nil) {
            let info = notif?.object as! NSDictionary?
            self.loadWeatherData(info?.object(forKey: "location") as? CLLocation)
        }
    }
    
    func loadWeatherData(_ location:CLLocation?) -> Void {
        
        WeatherApi.sharedInstance.getWeatherDictionaryByLocation(location, completion: { (responseObject:NSDictionary?, error:NSError?) in
            if error != nil {
                NSLog("error \(error)")
                DispatchQueue.main.async {
                    self.updateDisplayData(DataManager.sharedInstance.loadWeatherData())
                }
            } else {
                NSLog("response data: \(responseObject)")
                DataManager.sharedInstance.saveData(responseObject, completion: { (savedWeatherObject: WeatherData?, error:NSError? ) in
                    DispatchQueue.main.async {
                        self.updateDisplayData(savedWeatherObject)
                    }
                })
            }
        })
    }
    
    func updateDisplayData(_ weather:WeatherData?) -> Void {
        if (weather != nil) {
            if (weather!.degree != nil) {
                self.celsiusLabel.text = "℃"
                self.degreeLabel.text = String(format:"%.1f", weather!.degree!)
            }
            if (weather!.city != nil) {
                self.cityLabel.text = weather!.city!;
                self.cityLabel.sizeToFit()
            }
            if (weather!.shortDescription != nil) {
                self.detailsLabel.text = weather!.shortDescription!
            }
            if (weather!.windSpeed != nil) {
                let windStr = String(format:"%.1f", weather!.windSpeed!)
                self.windLabel.text = "Скорость ветра \(windStr) м/с"
            }
            if (weather!.time != nil) {
                let timeString = lastUpdatedFormatter.string(from: weather!.time! as Date)
                self.lastUpdatedTime.text = String(format: "Последнее обновление:\n%@", timeString)
            }
        }
    }
    
    @IBAction func reloadData(_ sender: UIButton) {
        self.loadWeatherData(LocationManager.sharedInstance.currentLocation)
    }
}

