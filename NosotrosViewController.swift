//
//  NosotrosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/11/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NosotrosViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var manager = CLLocationManager()
    var latitud : CLLocationDegrees!
    var longitud : CLLocationDegrees!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 19.73429843,                                longitude:  -101.19854656)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapa.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Black GYM"
        mapa.addAnnotation(annotation)
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
    }
    

}
