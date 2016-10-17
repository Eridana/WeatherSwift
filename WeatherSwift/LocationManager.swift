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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (currentLocation != nil) {
            if (locations.last != currentLocation) {
                currentLocation = locations.last
                self.sendNotification()
            }
        } else {
            currentLocation = locations.last
            self.sendNotification()
        }
    }
    
    func sendNotification() -> Void {
        if (currentLocation != nil) {
            let info : [String:AnyObject] = [ "location" : currentLocation! ]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "DidUpdateLocation"), object: info);
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationPermissionError"), object: nil);
            break
        default:
            locationManager.startUpdatingLocation()
            break
        }
    }
    
}
