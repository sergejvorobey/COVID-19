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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var countries = [Country]()
    private var filteredCountries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar()
        parseData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        tableView.addSubview(self.refreshControll)
    }
    
    // refresh spinner
    lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControll.tintColor = UIColor.black
        return refreshControll
        
    }()
    
    @objc func handleRefresh(_ refreshControll: UIRefreshControl) {
        
        self.tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
//        tableView.reloadData()
        //TO DO: return to first item in table view
    }
}

// MARK: Table View DataSource, and Delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountries.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let countryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        
        var country: Country
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
  
        countryCell.countryLabel.text = country.name
        countryCell.cases.text = country.cases?.description 
        countryCell.deaths.text = country.deaths?.description
        countryCell.recovered.text = country.recovered?.description
        countryCell.todayCases.text = country.todayCases?.description
        countryCell.todayDeaths.text = country.todayDeaths?.description
        
        let datePublic = country.updated!
        let date = Date(timeIntervalSince1970: TimeInterval(datePublic / 1000))
        
        countryCell.timeUpdate.text = date.publicationDate(withDate: date)
//        countryCell.countryFlag.image = UIImage(data: try! Data(contentsOf: URL(string: country.countryInfo!.flag!)!))
        
//        let myImage = UIImage(named: country.countryInfo!.flag!)
//        func base64Convert(base64String: String?) -> UIImage {
//
//            var imageFlag: UIImage?
//
//            if (base64String?.isEmpty)! {
//                return #imageLiteral(resourceName: "no_image_found")
//            } else {
//                let url = URL(string: country.countryInfo!.flag!)
//                if let data = try? Data(contentsOf: url!)
//                {
//                    let image: UIImage = UIImage(data: data)!
//                    imageFlag = image
//                }
//                return imageFlag!
//            }
//        }

//        countryCell.countryFlag.image = base64Convert(base64String: country.countryInfo!.flag!)
    
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

// MARK: Convert Date
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

// MARK: Input Search Bar and design
extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBar () {

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Country"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = countries.filter({ (country: Country) -> Bool in
            return (country.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
}

extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}

//MARK: parse API data
extension MainViewController {
    
    private func parseData() {
        let dataLoader = DataLoaderAPI()
        dataLoader.getAllCountryName()
        dataLoader.completionHandler { [weak self] (countries, status, message) in
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
}
