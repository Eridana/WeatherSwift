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
    var time : NSDate?
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        self.degree = aDecoder.decodeObjectForKey("degree") as? Double
        self.shortDescription = aDecoder.decodeObjectForKey("shortDescription") as? String
        self.city = aDecoder.decodeObjectForKey("city") as? String
        self.windSpeed = aDecoder.decodeObjectForKey("windSpeed") as? Double
        self.time = aDecoder.decodeObjectForKey("time") as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.degree, forKey: "degree")
        aCoder.encodeObject(self.shortDescription, forKey: "shortDescription")
        aCoder.encodeObject(self.city, forKey: "city")
        aCoder.encodeObject(self.windSpeed, forKey: "windSpeed")
        aCoder.encodeObject(self.time, forKey: "time")
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "WeatherData")
    }
    
    func clear() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("WeatherData")
    }
    
    class func loadSaved() -> WeatherData? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("WeatherData") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? WeatherData
        }
        return nil
    }
    
}