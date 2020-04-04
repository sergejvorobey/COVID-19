//
//  ViewController.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 03/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Foundation


class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = DataLoaderAPI()/*countryData*/
    //    var dataTest = DataLoaderAPI().array
    var countries = [Country]()
    var countryData = [CountryData]()
    
    //    var arr = CountryInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let service = Service()
        service.getAllCountryName()
        service.completionHandler { [weak self] (countries, status, message) in
            if status {
                guard let self = self else {return}
                guard let _countries = countries else {return}
                self.countries = _countries
                self.countries.sort(by: {Int($0.cases!) > Int($1.cases!)})
//                print(countries)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let countryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        
        let country = countries[indexPath.row]
//        let countryData = countryData[indexPath.row]
        //
        countryCell.countryLabel.text = country.name
        countryCell.cases.text = country.cases?.description
        countryCell.deaths.text = country.deaths?.description
        countryCell.recovered.text = country.recovered?.description
        countryCell.todayCases.text = country.todayCases?.description
        countryCell.todayDeaths.text = country.todayDeaths?.description
        
        let datePublic = country.updated!
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        
        countryCell.timeUpdate.text = date.publicationDate(withDate: date)
//        countryCell.countryFlag.image = country.flag
//        countryCell.cases.text = co
        

        
        
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
        
    }
    
    
}


extension Date {
    func publicationDate(withDate date: Date) -> String {
        
        var currentDatePublic = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        currentDatePublic = formatter.string(from: date)
        return currentDatePublic
    }
}
