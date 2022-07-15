//
//  UserAnnotation.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 15/7/22.
//
import MapKit
import CoreLocation

class UserAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
