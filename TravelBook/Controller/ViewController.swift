//
//  ViewController.swift
//  TravelBook
//
//  Created by Büşra Özkan on 15.11.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }


}

