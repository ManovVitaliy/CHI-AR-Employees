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
    var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    //MARK: - constants
    static let keyUserName = "name"
    static let keyUserID = "id"
    static let keyUserLatitude = "latitude"
    static let keyUserLongitude = "longitude"
    
    // convert model User to dictionary
    class func fromModelToDict(user: User) -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        let dictHelper = [User.keyUserName: user.name,
                          User.keyUserID: user.id,
                          User.keyUserLatitude: user.currentCoordinate.latitude,
                          User.keyUserLongitude: user.currentCoordinate.longitude] as [String : Any]
        dict = [user.name: dictHelper] as [String : AnyObject]
        
        return dict
    }
}
