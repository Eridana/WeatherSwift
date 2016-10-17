//
//  WeatherData.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 18.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class WeatherData: NSObject, NSCoding {
    
    var degree : Double?
    var shortDescription: String?
    var city : String?
    var windSpeed : Double?
    var time : Date?
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        self.degree = aDecoder.decodeObject(forKey: "degree") as? Double
        self.shortDescription = aDecoder.decodeObject(forKey: "shortDescription") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.windSpeed = aDecoder.decodeObject(forKey: "windSpeed") as? Double
        self.time = aDecoder.decodeObject(forKey: "time") as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.degree, forKey: "degree")
        aCoder.encode(self.shortDescription, forKey: "shortDescription")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.windSpeed, forKey: "windSpeed")
        aCoder.encode(self.time, forKey: "time")
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "WeatherData")
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: "WeatherData")
    }
    
    class func loadSaved() -> WeatherData? {
        if let data = UserDefaults.standard.object(forKey: "WeatherData") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? WeatherData
        }
        return nil
    }
    
}
