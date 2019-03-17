//
//  LocationManager.swift
//  CHI-AR-Employees
//
//  Created by user on 12/24/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject {

    static let sharedInstanse = LocationManager()
    var locationManager: CLLocationManager?
    
    func locationManager(delegate: CLLocationManagerDelegate) {
        locationManager = CLLocationManager()
        locationManager?.delegate = delegate
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 1.0
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
}
