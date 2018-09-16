//
//  FirstViewController.swift
//  Prototipo02_TCC
//
//  Created by Matheus Pedrosa on 06/06/17.
//  Copyright © 2017 Matheus Pedrosa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var annotationListTableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnGoToUserLocation: UIButton!
    @IBOutlet weak var btnAddAnnotation: UIButton!
    @IBOutlet weak var btnViewAnnotationList: UIButton!
    @IBOutlet weak var btnCopyAnnotationCoordinate: UIButton!
    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var lblBearing_2: UILabel!
    @IBOutlet weak var lblBearing_1: UILabel!
    @IBOutlet weak var lblBearing0: UILabel!
    @IBOutlet weak var lblBearing1: UILabel!
    @IBOutlet weak var lblBearing2: UILabel!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    
    let manager = CLLocationManager()
    let annotation = MKPointAnnotation()
    
    var regionBtnAction:MKCoordinateRegion?
    var headingBtnAction:CLLocationDirection?
    var altimeter: CMAltimeter!
    var totalAltitude = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultManager()
        azimuthManager()
        editButtonLayout()
        editLabelLayout()
        isBarometerAvailable()
        
    }
    
    @IBAction func btnGoToUserLocationAction(_ sender: UIButton) {
        mapView.setRegion(regionBtnAction!, animated: true)
        //mapView.camera.heading = headingBtnAction!
        //mapView.setCamera(mapView.camera, animated: true)
    }
    
    @IBAction func btnCopyAnnotationCoordinateAction(_ sender: UIButton) {
        UIPasteboard.general.string = String(lblLatitude.text! + "," + lblLongitude.text!)
        
        let alertController = UIAlertController(title: "", message: "Coordenadas copiadas para a área de transferência", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in print("")}))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnAddAnnotationAction(_ sender: UIButton) {
        annotation.coordinate = CLLocationCoordinate2DMake(Double(lblLatitude.text!)!, Double(lblLongitude.text!)!)
        mapView.addAnnotation(annotation)
    }
    
    func defaultManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func azimuthManager(){
        if CLLocationManager.headingAvailable() {
            manager.headingFilter = 1
            manager.startUpdatingHeading()
            manager.delegate = self
        }
    }
    
    func isBarometerAvailable(){
       
        if(CMAltimeter.isRelativeAltitudeAvailable()){
            print("Barômetro encontrado")
            altimeter = CMAltimeter()
            let queue = OperationQueue.main
            altimeter.startRelativeAltitudeUpdates(to: queue, withHandler: { (data, error) in
                if let values = data {
                    
                    //ALTITUDE: metros
                    self.totalAltitude = Double(values.relativeAltitude)
                    self.lblAltitude.text = NSString(format: "%.1f m", self.totalAltitude).description
                    print("altitude: " + NSString(format: "%.1f m", self.totalAltitude).description)
                    
                    //PRESSÃO: kPa para atm
                    let atm = Double(values.pressure) /* / 101.325 */
                    self.lblSpeed.text = NSString(format: "%.6f kPa", atm).description
                    print("pressão: " + NSString(format: "%.6f kPa", atm).description)
                    
                }
            })
        }
    }

    func editButtonLayout(){
        btnViewAnnotationList.layer.cornerRadius = 5
        btnViewAnnotationList.layer.borderWidth = 1
        btnViewAnnotationList.layer.borderColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0).cgColor
        btnViewAnnotationList.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btnViewAnnotationList.tintColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0)
        
        btnAddAnnotation.layer.cornerRadius = 5
        btnAddAnnotation.layer.borderWidth = 1
        btnAddAnnotation.layer.borderColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0).cgColor
        btnAddAnnotation.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btnAddAnnotation.tintColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0)
        
        btnCopyAnnotationCoordinate.layer.cornerRadius = 5
        btnCopyAnnotationCoordinate.layer.borderWidth = 1
        btnCopyAnnotationCoordinate.layer.borderColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0).cgColor
        btnCopyAnnotationCoordinate.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1)
        btnCopyAnnotationCoordinate.tintColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0)
        
        btnGoToUserLocation.layer.cornerRadius = 5
        btnGoToUserLocation.layer.borderWidth = 1
        btnGoToUserLocation.layer.borderColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0).cgColor
        btnGoToUserLocation.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1.0)
        btnGoToUserLocation.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btnGoToUserLocation.tintColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0)
    }
    
    func editLabelLayout(){
        lblLatitude.layer.cornerRadius = 5
        lblLatitude.layer.borderWidth = 1
        lblLatitude.layer.borderColor = UIColor.darkGray.cgColor
        lblLatitude.layer.backgroundColor = UIColor.darkGray.cgColor
        
        lblLongitude.layer.cornerRadius = 5
        lblLongitude.layer.borderWidth = 1
        lblLongitude.layer.borderColor = UIColor.darkGray.cgColor
        lblLongitude.layer.backgroundColor = UIColor.darkGray.cgColor
        
        lblBearing0.layer.cornerRadius = 5
        lblBearing0.layer.borderWidth = 1
        lblBearing0.layer.borderColor = UIColor.darkGray.cgColor
        lblBearing0.layer.backgroundColor = UIColor.darkGray.cgColor
        
        lblBearing_2.layer.opacity = 0.1
        lblBearing_1.layer.opacity = 0.5
        lblBearing1.layer.opacity = 0.5
        lblBearing2.layer.opacity = 0.1
        
        lblAltitude.layer.cornerRadius = 5
        lblAltitude.layer.borderWidth = 1
        lblAltitude.layer.borderColor = UIColor.darkGray.cgColor
        lblAltitude.layer.backgroundColor = UIColor.darkGray.cgColor
        
        lblSpeed.layer.cornerRadius = 5
        lblSpeed.layer.borderWidth = 1
        lblSpeed.layer.borderColor = UIColor.darkGray.cgColor
        lblSpeed.layer.backgroundColor = UIColor.darkGray.cgColor
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        regionBtnAction = region
        
        mapView.mapType = .standard
        
        mapView.setRegion(region, animated: true)
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.tintColor = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.0)
        
        lblLatitude.text = NSString(format: "%.8f", location.coordinate.latitude).description
        lblLongitude.text = NSString(format: "%.8f", location.coordinate.longitude).description
        //lblAltitude.text = NSString(format: "%.1f m", location.altitude).description
        
//        switch (location.speed * 3.6) {
//        case let x where x < 0:
//            lblSpeed.text = "0 km/h"
//        case let x where x >= 0:
//            lblSpeed.text = NSString(format: "%.0f km/h", location.speed * 3.6).description
//        default:
//            lblSpeed.text = NSString(format: "%.0f km/h", location.speed * 3.6).description
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingBtnAction = newHeading.magneticHeading
        //mapView.camera.heading = newHeading.magneticHeading
        //mapView.setCamera(mapView.camera, animated: true)
        
        lblBearing_2.text = NSString(format: "%.0f", newHeading.magneticHeading-2).description
        lblBearing_1.text = NSString(format: "%.0f", newHeading.magneticHeading-1).description
        lblBearing0.text = NSString(format: "%.0f", newHeading.magneticHeading).description + "º"
        lblBearing1.text = NSString(format: "%.0f", newHeading.magneticHeading+1).description
        lblBearing2.text = NSString(format: "%.0f", newHeading.magneticHeading+2).description
        
        switch newHeading.magneticHeading {
        case let x where x > 67 && x < 113:
            lblHeading.text = "L"
            lblHeading.textColor = UIColor.black
        case let x where x > 247 && x < 293:
            lblHeading.text = "O"
            lblHeading.textColor = UIColor.black
        case let x where x > 292 && x < 337:
            lblHeading.text = "NO"
            lblHeading.textColor = UIColor.black
        case let x where x > 338 && x < 23:
            lblHeading.text = "N"
            lblHeading.textColor = UIColor.red
        case let x where x > 24 && x < 68:
            lblHeading.text = "NE"
            lblHeading.textColor = UIColor.black
        case let x where x > 112 && x < 158:
            lblHeading.text = "SE"
            lblHeading.textColor = UIColor.black
        case let x where x > 157 && x < 203:
            lblHeading.text = "S"
            lblHeading.textColor = UIColor.black
        case let x where x > 202 && x < 248:
            lblHeading.text = "SO"
            lblHeading.textColor = UIColor.black
        default:
            lblHeading.text = "N"
            lblHeading.textColor = UIColor.red
        }

    }

}

