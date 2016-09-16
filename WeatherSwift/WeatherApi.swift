//
//  WeatherApi.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 15.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import Foundation
import CoreLocation

typealias ApiResponse = (NSDictionary?, NSError?) -> Void

class WeatherApi: NSObject {
    
    class var sharedInstance:WeatherApi {
        struct Singleton {
            static let instance = WeatherApi()
        }
        return Singleton.instance
    }
    
    func getWeatherDictionaryByLocation(location : CLLocation?, completion: (ApiResponse)) -> Void
    {
        var url = "http://api.openweathermap.org/data/2.5/weather?units=metric&lang=ru&APPID=6e31ea25c4777f9418f524e9840ca640"
        
        if (location != nil) {
            url = url + String(format: "&lat=%.2f&lon=%.2f", (location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        } else {
            url = url + "&q=ufa"
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                    completion(json, nil)
                    
                } catch {
                    // Something went wrong
                }
            }
        }).resume()
    }
}