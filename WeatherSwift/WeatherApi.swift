//
//  WeatherApi.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 15.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

typealias ApiResponse = (NSDictionary?, NSError?) -> Void

class WeatherApi: NSObject {
    
    class var sharedInstance:WeatherApi {
        struct Singleton {
            static let instance = WeatherApi()
        }
        return Singleton.instance
    }
    
    func getWeatherDictionaryFromUrl(completion: ApiResponse) -> Void
    {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=ufa&units=metric&APPID=6e31ea25c4777f9418f524e9840ca640")!, completionHandler: { (data, response, error) -> Void in
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