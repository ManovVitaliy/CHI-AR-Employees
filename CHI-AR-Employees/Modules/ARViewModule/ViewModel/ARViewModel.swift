//
//  ARViewModel.swift
//  CHI-AR-Employees
//
//  Created by user on 2/26/19.
//  Copyright © 2019 Vitaliy Manov. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import ARKit

class ARViewModel: NSObject {
    
    //MARK: - properties
    private let arModel: ARModel = ARModel()
    //MARK: - observable values
    var currentPosition = Variable(SCNVector3(0, 0, 0))
    var myNodes = Variable([SCNNode]())
    
    
    
    override init() {
        super.init()
        arModel.user.name = "Vitaliy Manov"
//        LocationManager.sharedInstanse.locationManager(delegate: self)
    }
}

extension ARViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error is = \(error.localizedDescription)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocation = manager.location!
        arModel.user.currentLocation = locValue
        FirebaseService.sharedInstance.updateUserLocation(user: arModel.user) { [weak self] in
            self?.currentPosition.value = SCNVector3(locValue.coordinate.latitude,
                                                     locValue.coordinate.longitude,
                                                     locValue.altitude)
            let node = SCNNode()
            node.position = (self?.currentPosition.value)!
            self?.myNodes.value = [node]
        }
    }
}
