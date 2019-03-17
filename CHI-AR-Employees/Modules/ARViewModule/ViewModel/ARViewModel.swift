//
//  ARViewModel.swift
//  CHI-AR-Employees
//
//  Created by user on 2/26/19.
//  Copyright © 2019 Vitaliy Manov. All rights reserved.
//

import Foundation
import CoreLocation

class ARViewModel: NSObject {
    
    //MARK: - properties
    private let arModel: ARModel = ARModel()
    
    override init() {
        super.init()
        arModel.user.name = "Vitaliy Manov"
        LocationManager.sharedInstanse.locationManager(delegate: self)
    }
}

extension ARViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error is = \(error.localizedDescription)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocation = manager.location!
        print("Current Locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude) \(locValue.altitude)")
        arModel.user.currentLocation = locValue
        FirebaseService.sharedInstance.updateUserLocation(user: arModel.user) {
            print("user was updated")
        }
    }
}
