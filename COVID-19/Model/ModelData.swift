//
//  ModelData.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 03/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct CountryData: Decodable {
    
    var cases: String?
//    var todayCases: String?
//    var deaths: String?
//    var todayDeaths: String?
//    var recovered: String?
//    var updated: String?
    
    enum CodingKeys: String, CodingKey {
        //            case name = "country"
        case cases = "cases"
//        case todayCases = "todayCases"
//        case deaths = "deaths"
//        case todayDeaths = "todayDeaths"
//        case recovered = "recovered"
//        case updated = "updated"
        //            case flag = ["countryInfo":"flag"] as! [String: Any]
        //            case countryInfo = "countryInfo"
    }
}

