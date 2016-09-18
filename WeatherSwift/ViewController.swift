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
    var timer : NSTimer!
    var formatter : NSDateFormatter!
    var lastUpdatedFormatter : NSDateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter = NSDateFormatter()
        lastUpdatedFormatter = NSDateFormatter()
        lastUpdatedFormatter.dateFormat = "Последнее обновление:\nEEEE dd MMMM, HH:mm:ss"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(updateCurrentDate), userInfo: nil, repeats: true)
         self.updateDisplayData(DataManager.sharedInstance.loadWeatherData())
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(locationUpdated(_:)),
            name: "DidUpdateLocation",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(errorFetchLocation),
            name: "LocationPermissionError",
            object: nil)
        
        LocationManager.sharedInstance.startUpdatingUserLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func updateCurrentDate() -> Void {

        formatter.dateFormat = "EEEE dd MMMM"
        self.dateLabel.text = formatter.stringFromDate(NSDate())
        
        formatter.dateFormat = "HH:mm:ss"
        self.timeLabel.text = formatter.stringFromDate(NSDate())
    }

    func errorFetchLocation() -> Void {
        self.loadWeatherData(nil)
    }
    
    func locationUpdated(notif:NSNotification?) -> Void {
        if (notif != nil) {
            let info = notif?.object as! NSDictionary?
            self.loadWeatherData(info?.objectForKey("location") as? CLLocation)
        }
    }
    
    func loadWeatherData(location:CLLocation?) -> Void {
        
        WeatherApi.sharedInstance.getWeatherDictionaryByLocation(location, completion: { (responseObject:NSDictionary?, error:NSError?) in
            if error != nil {
                NSLog("error \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateDisplayData(DataManager.sharedInstance.loadWeatherData())
                }
            } else {
                NSLog("response data: \(responseObject)")
                
                DataManager.sharedInstance.saveData(responseObject, completion: { (savedWeatherObject: WeatherData?, error:NSError? ) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.updateDisplayData(savedWeatherObject)
                    }
                })
            }
        })
    }
    
    func updateDisplayData(weather:WeatherData?) -> Void {
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
                self.lastUpdatedTime.text = lastUpdatedFormatter.stringFromDate(weather!.time!)
            }
        }
    }
    
    @IBAction func reloadData(sender: UIButton) {
        self.loadWeatherData(LocationManager.sharedInstance.currentLocation)
    }
}

