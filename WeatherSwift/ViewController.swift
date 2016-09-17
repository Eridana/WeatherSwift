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

    @IBOutlet var degreeLabel : UILabel!
    @IBOutlet var celsiusLabel : UILabel!
    @IBOutlet var cityLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var detailsLabel : UILabel!
    @IBOutlet var windLabel : UILabel!
    @IBOutlet var blurImage : UIImageView!
    var timer : NSTimer!
    var formatter : NSDateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter = NSDateFormatter()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(updateCurrentDate), userInfo: nil, repeats: true)
        
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
        
        let formatter = NSDateFormatter()
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
            } else {
                NSLog("response data: \(responseObject)")
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.showReceivedWeatherDataFromResponse(responseObject)
                }
            }
        })
    }
    
    func showReceivedWeatherDataFromResponse(responseObject: NSDictionary?) -> Void {
        
        let celsius = responseObject?.objectForKey("main")?.objectForKey("temp") as! Double
        self.degreeLabel.text = String(format:"%.1f", celsius)
        self.celsiusLabel.text = "℃"
        
        let city = responseObject?.objectForKey("name") as! String
        self.cityLabel.text = city;
        self.cityLabel.sizeToFit()
        
        let weatherArray = responseObject?.objectForKey("weather") as! NSArray
        let weatherData = weatherArray.objectAtIndex(0) as! NSDictionary
        var descr = weatherData.objectForKey("description") as! String
        descr.replaceRange(descr.startIndex...descr.startIndex, with: String(descr[descr.startIndex]).capitalizedString)
        self.detailsLabel.text = descr
        
        let windSpeed = responseObject?.objectForKey("wind")?.objectForKey("speed") as! Double
        let windStr = String(format:"%.1f", windSpeed)
        self.windLabel.text = "Скорость ветра \(windStr) м/с"
    }
    
    @IBAction func reloadData(sender: UIButton) {
        self.loadWeatherData(LocationManager.sharedInstance.currentLocation)
    }
}

