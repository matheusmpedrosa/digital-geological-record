//
//  SecondViewController.swift
//  Prototipo02_TCC
//
//  Created by Matheus Pedrosa on 06/06/17.
//  Copyright © 2017 Matheus Pedrosa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultManager()
        
    }
    
    func defaultManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.mapType = .satelliteFlyover
        
        //mapView.setRegion(region, animated: true)
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.tintColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0)
    }

}

