//
//  DataManager.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 18.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

typealias SaveDataResponse = (WeatherData?, NSError?) -> Void

class DataManager : NSObject {
    
    class var sharedInstance:DataManager {
        struct Singleton {
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    
    func saveData(response : NSDictionary?, completion: (SaveDataResponse)) -> Void {
        
        var weatherObject = self.loadWeatherData()
        
        if (weatherObject == nil) {
            weatherObject = WeatherData()
        }
        
        if (response != nil) {
            
            weatherObject!.degree = response?.objectForKey("main")?.objectForKey("temp") as? Double
            weatherObject!.city = response?.objectForKey("name") as? String
            weatherObject!.windSpeed = response?.objectForKey("wind")?.objectForKey("speed") as? Double
            
            let weatherArray = response?.objectForKey("weather") as! NSArray
            let weatherData = weatherArray.objectAtIndex(0) as! NSDictionary
            
            var descr = weatherData.objectForKey("description") as? String
            if (descr != nil) {
                descr!.replaceRange(descr!.startIndex...descr!.startIndex, with: String(descr![descr!.startIndex]).capitalizedString)
                weatherObject!.shortDescription = descr!
            }
            
            weatherObject?.time = NSDate()
        }
        
        weatherObject!.save()
        completion(weatherObject!, nil)
    }
    
    func loadWeatherData() -> WeatherData?  {
        return WeatherData.loadSaved()
    }
}