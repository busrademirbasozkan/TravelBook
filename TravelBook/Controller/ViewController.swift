//
//  ViewController.swift
//  TravelBook
//
//  Created by Büşra Özkan on 15.11.2022.
//

import UIKit
import MapKit
import CoreLocation // kullanıcının konumunu alabilmek için ilgili kütüphane
import CoreData

class ViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // locationı ne kadar doğrulukla görüntülemesini sağlıyoruz.
        locationManager.requestWhenInUseAuthorization() // kullanıcının konumuna ne zaman ulaşacağımızı seçmeliyiz.
        locationManager.startUpdatingLocation() // kullanıcı konumu bu komut ile alınmaya başlanıyor
        
        //Recognizers
        // pinleme işlemi
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: ))) //uzun basınca çağırılacak
        gestureRecognizer.minimumPressDuration = 2 // kullanıcının minimum ne kadar süre basacağını belirleriz.
        mapView.addGestureRecognizer(gestureRecognizer)
         
        //HideKeyboard
        let gestureKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureKeyboard)
        
    }
    
    //HideKeyboard
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    //Save Button
    @IBAction func saveButton(_ sender: Any) {
        //CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlaces = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlaces.setValue(nameTextField.text!, forKey: "name")
        newPlaces.setValue(commentTextField.text!, forKey: "comment")
        newPlaces.setValue(UUID(), forKey: "id")
        newPlaces.setValue(chosenLatitude, forKey: "latitude")
        newPlaces.setValue(chosenLongitude, forKey: "longitude")
        
        do{
            try context.save()
        }catch{
            
        }
        
    }
    
    //pinleme fonksiyonu
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){ //içerisine input koyunca bu fonksiyonda otomatik olarak gestureRecognizer ve attributelarına ulaşabilirim.
        if gestureRecognizer.state == .began{ // öncelikle dokunma başladı mı bunu kontrol etmek gerekiyor.
            let touchedPoint = gestureRecognizer.location(in: self.mapView) // dokunulan yerin locationu alınır.
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView) // locationun koordinatları belirlendi.
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            //pin ekleme
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameTextField.text
            annotation.subtitle = commentTextField.text
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // alınan locationlarla ne işlem yapacağımızı belirlediğimiz fonksiyon
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)  // oluşan bir locationa zoomlamak için
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // zoom seviyesi seçmemiz gerek
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }


}

