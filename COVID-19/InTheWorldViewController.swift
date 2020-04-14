//
//  InTheWorldViewController.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 10/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Charts

class InTheWorldViewController: UIViewController {
    
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var todayCasesLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var todayDeathsLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    private var countries = [Country]()
    private var allCountElements = [String: Int]()
    private var provideToCharts = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseData()
        
        //        setChart(dictionary: allCountElements)
        
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
                self.navigationItem.title = "Статистика в мире"
                
                var casesCount = 0
                var todayCasesCount = 0
                var deathsCount = 0
                var todayDeathsCount = 0
                var recoveredCount = 0
                
                var dictionaryCount = [String: Int]()
                
                for country in countries! {
                    casesCount += country.cases!
                    todayCasesCount += country.todayCases!
                    deathsCount += country.deaths!
                    todayDeathsCount += country.todayDeaths!
                    recoveredCount += country.recovered!
                    
                    dictionaryCount = ["cases": casesCount,
                                       "todayCasesCount": todayCasesCount,
                                       "deathsCount": deathsCount,
                                       "todayDeathsCount": todayDeathsCount,
                                       "recoveredCount": recoveredCount]
                    
//                    dictionaryCount = ["Зараженных:": casesCount,
//                                       "Зараженных в сутки:": todayCasesCount,
//                                       "Смертей:": deathsCount,
//                                       "Смертей в сутки:": todayDeathsCount,
//                                       "Излечилось": recoveredCount]
                }
                
                self.allCountElements = dictionaryCount
                
                self.casesLabel.text = "Зараженных: \(self.allCountElements["cases"] ?? 0)"
                self.todayCasesLabel.text = "Зараженных за сутки: \(self.allCountElements["todayCasesCount"] ?? 0)"
                self.deathsLabel.text = "Смертей: \(self.allCountElements["deathsCount"] ?? 0)"
                self.todayDeathsLabel.text = "Смертей за сутки: \(self.allCountElements["todayDeathsCount"] ?? 0)"
                self.recoveredLabel.text = "Выздоровели: \(self.allCountElements["recoveredCount"] ?? 0)"
                
                self.provideToCharts = ["Зараженных:": casesCount,
                                        "Зараженных в сутки:": todayCasesCount,
                                        "Смертей:": deathsCount,
                                        "Смертей в сутки:": todayDeathsCount,
                                        "Излечилось": recoveredCount]
                var keys = [String]()
                var values = [Int]()
                
                for (key, value) in self.provideToCharts {
                    
                    keys.append(key)
                    values.append(value)
                }
                
                self.setChart(dataPoints: keys, values: values)
            }
        }
    }
}

extension InTheWorldViewController {
    
    func setChart(dataPoints: [String], values: [Int]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = PieChartDataEntry(value: Double(values[i]), label: dataPoints[i], data: dataPoints[i] as AnyObject)
            
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        
        pieChartData.setValueFormatter(formatter)
        
        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        
        var colors: [UIColor] = []
        
        for _ in 0..<numbersOfColor {
            
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colors.append(color)
        }
        return colors
    }
}
