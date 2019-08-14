//
//  MapLocation.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 10/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import UIKit
import MapKit

class MapLocation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String? { return "I'm at \(coordinate.latitude) and \(coordinate.longitude)" }
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
}
