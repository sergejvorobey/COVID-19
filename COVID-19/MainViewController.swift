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
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar()
        parseData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //        loadMore()
        //        scrollViewDidScroll(scrollView: UIScrollView())
        
        tableView.addSubview(self.refreshControll)
        
    }
    
    //MARK: parse API data
    private func parseData() {
        
        let dataLoader = DataLoaderAPI()
        dataLoader.getAllCountryName()
        
        dataLoader.completionHandler { [weak self] (countries, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _countries = countries else {return}
                self.countries = _countries
                self.countries.sort(by: {Int($0.cases!) > Int($1.cases!)})
                self.navigationItem.title = "\(self.countries.count) Стран"
            
                self.tableView.reloadData()
            }
        }
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
        
        scrollToFirstRow()
    }
    
    @IBAction func infoButton(_ sender: UIBarButtonItem) {
        
        var time = 0
        
        for item in countries {
            time = item.updated!
        }
        let datePublic = time
        let date = Date(timeIntervalSince1970: TimeInterval(datePublic / 1000))
        let dateUpdate = date.publicationDate(withDate: date)
        alertInfo(withMessage: dateUpdate)
    }
    
    //scroll to top
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        countryCell.accessoryType = .disclosureIndicator
        
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CountryInfoViewController" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let country: Country
            
            if isFiltering {
                country = filteredCountries[indexPath.row]
            } else {
                country = countries[indexPath.row]
            }
            
            let countryInfoVC = segue.destination as! CountryInfoViewController
            
            countryInfoVC.infoCountry = country
        }
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

extension MainViewController {
    
    func alertInfo(withMessage message: String) {
        
        let alertController = UIAlertController(title: "Последнее обновление данных: ",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Назад", style: .default, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}
