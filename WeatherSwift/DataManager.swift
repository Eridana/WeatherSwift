//
//  DataManager.swift
//  WeatherSwift
//
//  Created by Evgeniya Mikhailova on 18.09.16.
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
        
        let weatherObject = self.loadWeatherData() ?? WeatherData()
        
        if let response = response {
            if let mainDict = response.object(forKey: "main") as? NSDictionary {
                weatherObject.degree = mainDict.object(forKey: "temp") as? Double
            }
            if let windDict = response.object(forKey: "wind") as? NSDictionary {
                weatherObject.windSpeed = windDict.object(forKey: "speed") as? Double
            }
            weatherObject.city = response.object(forKey: "name") as? String
            let weatherArray = response.object(forKey: "weather") as? NSArray
            if let weatherData = weatherArray?.object(at: 0) as? NSDictionary {
                if let description = weatherData.object(forKey: "description") as? String {
                    weatherObject.shortDescription = description.firstLetterCapitalizedString()
                }
            }            
            weatherObject.time = Date()
        }
        
        weatherObject.save()
        completion(weatherObject, nil)
    }
    
    func loadWeatherData() -> WeatherData?  {
        return WeatherData.loadSaved()
    }
}
