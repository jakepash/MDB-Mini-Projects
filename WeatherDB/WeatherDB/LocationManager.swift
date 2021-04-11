//
//  LocationManager.swift
//  WeatherDB
//
//  Created by Michael Lin on 3/21/21.
//

import Foundation
import CoreLocation

//current location signleton
var currentLocation: CLLocation?

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    // We call this function at didFinishLaunchingWithOptions because
    // static variables are lazily initialized, and we want to minimize
    // the delay of getting the first location.
    static func configure() { let _ = shared }
    
    let manager = CLLocationManager()
    
    
	
	
    
    override init() {
        super.init()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.distanceFilter = 1000
        manager.requestLocation()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		Singleton.shared.currentLocation = locations.first
		
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
