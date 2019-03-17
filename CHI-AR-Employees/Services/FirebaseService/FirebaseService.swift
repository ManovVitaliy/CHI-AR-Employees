//
//  FirebaseService.swift
//  CHI-AR-Employees
//
//  Created by user on 12/24/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseService: NSObject {

    // singletone
    static let sharedInstance = FirebaseService()
    
    //constants
    private let keyUser = "users"
    
    //MARK: - POST
    func postUser(user: User, completion: @escaping(() -> Void)) {
        let firebaseUser = Database.database().reference().child(keyUser)
        let dict = User.fromModelToDict(user: user)
        firebaseUser.updateChildValues(dict)
        completion()
    }
    
    //MARK: - UPDATE
    func updateUserLocation(user: User, completion: @escaping(() -> Void)) {
        let firebaseUser = Database.database().reference().child(keyUser).child(String(user.name))
        let dict = [User.keyUserLatitude: user.currentLocation.coordinate.latitude,
                    User.keyUserLongitude: user.currentLocation.coordinate.longitude,
                    User.keyUserAltitude: user.currentLocation.altitude]
        firebaseUser.updateChildValues(dict)
        completion()
    }
}
