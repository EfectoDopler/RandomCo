//
//  RCHomeViewController+Location.swift
//  RandomCo
//
//  Created by José Escudero on 13/11/21.
//

import Foundation
import CoreLocation

extension RCHomeViewController: CLLocationManagerDelegate {
    
    func checkLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager.delegate = self // Hace el controlador delegado de CLLocationManager
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // Elige el grado de precisión
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if let pos = locationManager.location {
            let lat = pos.coordinate.latitude
            let lon = pos.coordinate.longitude
            let myCoords = Coordinate(latitude: "\(lat)", longitude: "\(lon)")
            viewModel.addFilter(type: .distance, coord: myCoords)
        }
        
    }
}
