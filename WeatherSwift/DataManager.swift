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
    
    func saveData(_ response : NSDictionary?, completion: (SaveDataResponse)) -> Void {
        
        var weatherObject = self.loadWeatherData()
        
        if (weatherObject == nil) {
            weatherObject = WeatherData()
        }
        
        if (response != nil) {
            
            weatherObject!.degree = (response?.object(forKey: "main") as! NSDictionary).object(forKey: "temp") as? Double
            weatherObject!.city = response?.object(forKey: "name") as? String
            weatherObject!.windSpeed = (response?.object(forKey: "wind") as! NSDictionary).object(forKey: "speed") as? Double
            
            let weatherArray = response?.object(forKey: "weather") as! NSArray
            let weatherData = weatherArray.object(at: 0) as! NSDictionary
            
            let descr = weatherData.object(forKey: "description") as? String
            if (descr != nil) {
                weatherObject!.shortDescription = descr!.firstLetterCapitalizedString()
            }
            
            weatherObject?.time = Date()
        }
        
        weatherObject!.save()
        completion(weatherObject!, nil)
    }
    
    func loadWeatherData() -> WeatherData?  {
        return WeatherData.loadSaved()
    }
}
