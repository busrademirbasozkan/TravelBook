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
    @IBOutlet weak var saveClicked: UIButton!
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var selectedName = ""
    var selectedId : UUID?
    var annotationName = ""
    var annotationComment = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    
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
        
        //bilgileri gösterme
        if selectedName != "" {
            saveClicked.isHidden = true
            //CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            let idString = selectedId!.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString) //filtreleme işlemi yapıyoruz. Sadece bu id'ye ait alan bilgileri çağır.
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            annotationName = name
                            
                            if let comment = result.value(forKey: "comment") as? String{
                                annotationComment = comment
                                
                                if let latitude = result.value(forKey: "latitude") as? Double{
                                    annotationLatitude = latitude
                                    
                                    if let longitude = result.value(forKey: "longitude") as? Double{
                                        annotationLongitude = longitude
                                        
                                        //pinin tekrar gösterilmesi
                                        let annotation = MKPointAnnotation()
                                        annotation.title = annotationName
                                        annotation.subtitle = annotationComment
                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                        annotation.coordinate = coordinate
                                        
                                        mapView.addAnnotation(annotation)
                                        nameTextField.text = annotationName
                                        commentTextField.text = annotationComment
                                        
                                        locationManager.stopUpdatingLocation() // Kullanıcının yeni konumunu getirmemesi için. ilk kaydettiğim konumun gelebilmesi için
                                        //Güncel konum değil tıklanan locationın gösterilmesi için. Annotation oluştuma yapılır yine
                                        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        mapView.setRegion(region, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }catch{
            }
        }else{
        
        }
        
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
        
        //butona basınca tableviewa dönmek için
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
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
        if selectedName == ""{
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)  // oluşan bir locationa zoomlamak için
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03) // zoom seviyesi seçmemiz gerek
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "MyAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true // baloncuk ile ekstra bilgi gösterebildiğimiz yer
            pinView?.tintColor = UIColor.blue
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure) // detay göstereceğim bir buton
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }


}

