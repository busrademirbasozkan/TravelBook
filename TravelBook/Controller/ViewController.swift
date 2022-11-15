//
//  ViewController.swift
//  TravelBook
//
//  Created by Büşra Özkan on 15.11.2022.
//

import UIKit
import MapKit
import CoreLocation // kullanıcının konumunu alabilmek için ilgili kütüphane

class ViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // locationı ne kadar doğrulukla görüntülemesini sağlıyoruz.
        locationManager.requestWhenInUseAuthorization() // kullanıcının konumuna ne zaman ulaşacağımızı seçmeliyiz.
        locationManager.startUpdatingLocation() // kullanıcı konumu bu komut ile alınmaya başlanıyor
        
    }
    
    
   

}

