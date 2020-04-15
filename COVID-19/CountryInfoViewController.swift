//
//  CountryInfoViewController.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 09/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import MapKit

class CountryInfoViewController: UIViewController {
    
    var infoCountry: Country?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude = infoCountry?.countryInfo?.lat
        let longitude = infoCountry?.countryInfo?.long

        let coordinateCenter = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let mkAnnotation = MKPointAnnotation()
        mkAnnotation.title = infoCountry?.name
        mkAnnotation.subtitle = "Текущее количество зараженных: \(infoCountry?.cases ?? 0)"
        mkAnnotation.coordinate = coordinateCenter

        mapView.setCenter(coordinateCenter, animated: true)
        mapView.addAnnotation(mkAnnotation)
        
    }
}

