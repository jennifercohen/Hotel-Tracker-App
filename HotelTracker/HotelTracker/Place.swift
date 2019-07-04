//
//  Place.swift
// HotelTracker
//
//  Created by Jennifer Cohen on 26/06/2019.
//  Copyright © 2019 Jennifer Cohen. All rights reserved.
//

import Foundation
import MapKit
import Contacts


class Place: NSObject, MKAnnotation {
    
    //MARK: Initialisation
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let rating: Int
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D, rating: Int) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.rating = rating
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    //MARK: Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    //MARK: Color change of pin represents the number of stars a user has chosen to rate their hotel
    var markerTintColor: UIColor  {
        switch rating {
        case 0:
            return .red
        case 1:
            return .orange
        case 2:
            return .magenta
        case 3:
            return .purple
        case 4:
            return .blue
        default:
            return .green
        }
    }
    
}

