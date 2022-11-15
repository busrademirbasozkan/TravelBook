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
    
    
    // alınan locationlarla ne işlem yapacağımızı belirlediğimiz fonksiyon
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)  // oluşan bir locationa zoomlamak için
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // zoom seviyesi seçmemiz gerek
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
    }


}

