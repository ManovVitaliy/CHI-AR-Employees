//
//  User.swift
//  CHI-AR-Employees
//
//  Created by user on 12/24/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit
import CoreLocation

class User {
    //MARK: - properties
    var id: Int = 0
    var name: String = ""
    var currentLocation: CLLocation = CLLocation()
    
    //MARK: - constants
    static let keyUserName = "name"
    static let keyUserID = "id"
    static let keyUserLatitude = "latitude"
    static let keyUserLongitude = "longitude"
    static let keyUserAltitude = "altitude"
    
    // convert model User to dictionary
    class func fromModelToDict(user: User) -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        let dictHelper = [User.keyUserName: user.name,
                          User.keyUserID: user.id,
                          User.keyUserLatitude: user.currentLocation.coordinate.latitude,
                          User.keyUserLongitude: user.currentLocation.coordinate.longitude,
                          User.keyUserAltitude: user.currentLocation.altitude] as [String : Any]
        dict = [user.name: dictHelper] as [String : AnyObject]
        
        return dict
    }
}
