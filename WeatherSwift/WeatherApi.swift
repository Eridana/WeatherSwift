//
//  WeatherApi.swift
//  WeatherSwift
//
//  Created by Evgeniya Mikhailova on 15.09.16.
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
    
    func getWeatherDictionaryByLocation(_ location : CLLocation?, completion: @escaping (ApiResponse)) -> Void
    {
        let lang = "lang".localized
        var url = "http://api.openweathermap.org/data/2.5/weather?units=metric&lang=\(lang)&APPID=6e31ea25c4777f9418f524e9840ca640"
        
        if let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude {
            url = url + String(format: "&lat=%.2f&lon=%.2f", lat, lon)
        } else {
            url = url + "&q=lindau"
        }
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    completion(json as NSDictionary?, nil)
                    
                } catch {
                    // Something went wrong
                }
            }
        }).resume()
    }
}
