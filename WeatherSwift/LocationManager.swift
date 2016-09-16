//
//  LocationManager.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 16.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    class var sharedInstance:LocationManager {
        struct Singleton {
            static let instance = LocationManager()
        }
        return Singleton.instance
    }
    
    func startUpdatingUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if (currentLocation != nil) {
            if (newLocation != currentLocation) {
                currentLocation = newLocation
                self.sendNotification()
            }
        } else {
            currentLocation = newLocation
            self.sendNotification()
        }
    }
    
    func sendNotification() -> Void {
        if (currentLocation != nil) {
            let info : [String:AnyObject] = [ "location" : currentLocation! ]
            NSNotificationCenter.defaultCenter().postNotificationName("DidUpdateLocation", object: info);
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Denied:
            NSNotificationCenter.defaultCenter().postNotificationName("LocationPermissionError", object: nil);
            break
        default:
            locationManager.startUpdatingLocation()
            break
        }
    }
    
}