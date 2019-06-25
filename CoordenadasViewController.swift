//
//  CoordenadasViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/17/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CoordenadasViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var obtenerUbicacion: UIButton!
    @IBOutlet weak var mostrarCoordenadas: UILabel!
    
    var manager = CLLocationManager()
    var latitud : CLLocationDegrees!
    var longitu : CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationBlackGYM = CLLocationCoordinate2D(latitude: 19.73429843,                                longitude:  -101.19854656)
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest //traer la mejor localizacion
        manager.startUpdatingLocation()
        
        
        //marcador Black GYM
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationBlackGYM
        annotation.title = "Black GYM"
        mapa.addAnnotation(annotation)
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()

       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.latitud = location.coordinate.latitude
            self.longitu = location.coordinate.longitude
        }
    }
  
    @IBAction func obtenerUbicacion(_ sender: UIButton) {
        
        let Punto1 = CLLocation(latitude: latitud, longitude: longitu)
        let Punto2 = CLLocation(latitude: 19.73429843, longitude: -101.19854656)
        
        let DistanciaEnMetros = Punto1.distance(from: Punto2)
        
        print("La distancia en metros desde tu ubicacion al gym es de : \(DistanciaEnMetros) metros" )
        //mostrarCoordenadas.text = "La distancia al gym es de : \(DistanciaEnMetros) metros"
        mostrarCoordenadas.text = "Lat: \(latitud!), Long: \(longitu!),La distancia al gym es de : \(DistanciaEnMetros) metros "
        
        let localizacion = CLLocationCoordinate2DMake(latitud, longitu)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        mapa.setRegion(region, animated: true)
        mapa.showsUserLocation = true
        
    }
    
}
