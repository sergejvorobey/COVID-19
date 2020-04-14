//
//  BarChartViewController.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 14/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var casesData = PieChartDataEntry(value: 0)
    var toDayCasesData = PieChartDataEntry(value: 0)
    var deathsData = PieChartDataEntry(value: 0)
    var toDayDeathData = PieChartDataEntry(value: 0)
    var recoveredData = PieChartDataEntry(value: 0)
 
    
    let players = ["Зараженных", "Зараженных за сутки", "Смертей", "Смертей за сутки", "Вылечелось"]
    let goals = [6, 8, 26, 30, 8]
    
    //    var months: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.chartDescription?.text = ""
//        casesData.label = "Зараженных"
//        toDayCasesData.label = "Зараженных за сутки"
//        deathsData.label = "Смертей"
//        toDayDeathData.label = "Смертей за сутки"
//        recoveredData.label = "Вылечелось"
        
   
        
        setChart(dataPoints: players, values: goals)
        
    }
    
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
        format.numberStyle = .none
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

extension BarChartViewController {
    
    
}
