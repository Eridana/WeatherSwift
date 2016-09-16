//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 13.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var degreeLabel : UILabel!
    @IBOutlet var cityLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var detailsLabel : UILabel!
    @IBOutlet var blurImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWeatherData() -> Void {
        
        WeatherApi.sharedInstance.getWeatherDictionaryFromUrl { (responseObject:NSDictionary?, error:NSError?) in
            if error != nil {
                NSLog("error \(error)")
            } else {
                NSLog("response data: \(responseObject)")
                
                let celsius = responseObject?.objectForKey("main")?.objectForKey("temp") as! Double
                dispatch_async(dispatch_get_main_queue()) {
                    self.degreeLabel.text = String(format:"%.1f", celsius)
                }
                
                let city = responseObject?.objectForKey("name") as! String
                self.cityLabel.text = city;
                
                let weatherArray = responseObject?.objectForKey("weather") as! NSArray
                let weatherData = weatherArray.objectAtIndex(0) as! NSDictionary
                let descr = weatherData.objectForKey("description") as! String
                self.detailsLabel.text = descr
                
                let date = NSDate()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE"
                
                self.dateLabel.text = formatter.stringFromDate(date)
                formatter.dateFormat = "HH:mm"
                self.timeLabel.text = formatter.stringFromDate(date)
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

