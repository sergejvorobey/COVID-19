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
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var casesStackView: UIStackView!
    @IBOutlet weak var todayCasesStackView: UIStackView!
    @IBOutlet weak var deathsStackView: UIStackView!
    @IBOutlet weak var todayDeathsStackView: UIStackView!
    @IBOutlet weak var recoveredStackView: UIStackView!
    
    private var countries = [Country]()
    private var allCountElements = [String: Int]()
    private var provideToCharts = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseData()
        styleLabel()
      
    }
    
   private func styleLabel() {
        
        let baseColor = #colorLiteral(red: 0.1294117647, green: 0.1449416578, blue: 0.1574646831, alpha: 1)
        casesStackView.addBackground(color: baseColor, radiusSize: 10)
        todayCasesStackView.addBackground(color: baseColor, radiusSize: 10)
        deathsStackView.addBackground(color: baseColor, radiusSize: 10)
        todayDeathsStackView.addBackground(color: baseColor, radiusSize: 10)
        recoveredStackView.addBackground(color: baseColor, radiusSize: 10)
        
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
                
                guard let countries = countries else { return }
                
                for country in countries {
                    casesCount += country.cases!
                    todayCasesCount += country.todayCases!
                    deathsCount += country.deaths!
                    todayDeathsCount += country.todayDeaths!
                    recoveredCount += country.recovered!
                    let time = country.updated
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(time! / 1000))
                    self.lastUpdateLabel.text = "Последнее обновление: \(date.publicationDate(withDate: date))"
                    
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
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                
                let cases = formatter.string(from: self.allCountElements["cases"]! as NSNumber)
                let todayCases = formatter.string(from: self.allCountElements["todayCasesCount"]! as NSNumber)
                let deaths = formatter.string(from: self.allCountElements["deathsCount"]! as NSNumber)
                let todayDeaths = formatter.string(from: self.allCountElements["todayDeathsCount"]! as NSNumber)
                let recovered = formatter.string(from: self.allCountElements["recoveredCount"]! as NSNumber)
                
                self.casesLabel.text = "🦠 \(cases ?? "0")"
                self.todayCasesLabel.text = "🚑  \(todayCases ?? "0")"
                self.deathsLabel.text = "💀 \(deaths ?? "0")"
                self.todayDeathsLabel.text = "💀 \(todayDeaths ?? "0")"
                self.recoveredLabel.text = "💊 \(recovered ?? "0")"
                
                self.provideToCharts = ["Зараженных:": casesCount,
                                        "Зараженных в сутки:": todayCasesCount,
                                        "Смертей:": deathsCount,
                                        "Смертей в сутки:": todayDeathsCount,
                                        "Излечилось": recoveredCount]
                var keys = [String]()
                var values = [Double]()
                
                for (key, value) in self.provideToCharts {
                    
                    keys.append(key)
                    values.append(Double(value))
                }
                
                self.setChart(dataPoints: keys, values: values)
            }
        }
    }
}

// create chart
extension InTheWorldViewController {
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Статистика")
        
        barChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        // 3. Set ChartData
        let barChartData = BarChartData(dataSet: barChartDataSet)
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)

        barChartData.setValueFormatter(formatter)
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        // 4. Assign it to the chart’s data
        barChartView.data = barChartData
        
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

