//
//  Location.swift
//  TrackMyLocation
//
//  Created by Wismin Effendi on 6/30/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    var dateTime = Date()  // fix when we create the struct
    var coordinate: CLLocationCoordinate2D
    var placemark: CLPlacemark
    
    init(coordinate: CLLocationCoordinate2D, placemark: CLPlacemark) {
        self.coordinate = coordinate
        self.placemark = placemark
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        return "\(dateTimeString) \n \(latLonCoordinate) \n \(address)"
    }
    
    var address: String {
        let houseNumber = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let city = placemark.locality ?? ""
        let state = placemark.administrativeArea ?? ""
        let postalCode = placemark.postalCode ?? ""
        let country = placemark.country ?? ""
        return "\(houseNumber) \(street) \(city) \n \(state) \(postalCode) \(country)"
    }
    
    var latLonCoordinate: String {
        let latitude = Double(coordinate.latitude).format(f: ".4")   // 11m accuracy
        let longitude = Double(coordinate.longitude).format(f: ".4")
        return "Lat: \(latitude), Lon: \(longitude)"
    }
    
    var dateTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: dateTime)
    }
}


extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
