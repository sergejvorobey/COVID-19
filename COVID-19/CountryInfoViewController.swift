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
    
    @IBOutlet weak var casesCountryLabel: UILabel!
    @IBOutlet weak var todayCasesCountryLabel: UILabel!
    @IBOutlet weak var deathsCountryLabel: UILabel!
    @IBOutlet weak var todayDeathsCountryLabel: UILabel!
    @IBOutlet weak var recoveredCountryLabel: UILabel!
    
    @IBOutlet weak var casesStackView: UIStackView!
    @IBOutlet weak var todayCasesStackView: UIStackView!
    @IBOutlet weak var deathsStackView: UIStackView!
    @IBOutlet weak var todayDeathsStackView: UIStackView!
    @IBOutlet weak var recoveredStackView: UIStackView!
    
    var infoCountry: Country?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //         let image = UIImage(data: try! Data(contentsOf: URL(string: (infoCountry?.countryInfo!.flag!)!)!))
        
        let latitude = infoCountry?.countryInfo?.lat
        let longitude = infoCountry?.countryInfo?.long
        
        let coordinateCenter = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let mkAnnotation = MKPointAnnotation()
        mkAnnotation.title = infoCountry?.name
        //        mkAnnotation.subtitle = "Текущее количество зараженных: \(infoCountry?.cases ?? 0)"
        //        mkAnnotation.subtitle = "\(String(describing: image))"
        mkAnnotation.coordinate = coordinateCenter
        
        mapView.setCenter(coordinateCenter, animated: true)
        mapView.addAnnotation(mkAnnotation)
        
        styleStackView()
        
    }
    
    private func styleStackView() {
        
        dataLabels()
        
        let baseColor = #colorLiteral(red: 0.1294117647, green: 0.1449416578, blue: 0.1574646831, alpha: 1)
        casesStackView.addBackground(color: baseColor, radiusSize: 10)
        todayCasesStackView.addBackground(color: baseColor, radiusSize: 10)
        deathsStackView.addBackground(color: baseColor, radiusSize: 10)
        todayDeathsStackView.addBackground(color: baseColor, radiusSize: 10)
        recoveredStackView.addBackground(color: baseColor, radiusSize: 10)
        
    }
    
    private func dataLabels () {
        
        changeNavigationsItems()
        
        guard let infoCountry = infoCountry else {return}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        casesCountryLabel.text = formatter.string(from: infoCountry.cases! as NSNumber)
        todayCasesCountryLabel.text = formatter.string(from: infoCountry.todayCases! as NSNumber)
        deathsCountryLabel.text = formatter.string(from: infoCountry.deaths! as NSNumber)
        todayDeathsCountryLabel.text = formatter.string(from: infoCountry.todayDeaths! as NSNumber)
        recoveredCountryLabel.text = formatter.string(from: infoCountry.recovered! as NSNumber)
        
    }
    
    func changeNavigationsItems() {
        
        navigationItem.title = infoCountry?.name
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Назад",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
    }
}

