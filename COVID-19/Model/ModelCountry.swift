//
//  ModelCountry.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 03/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct Country: Decodable {
    
    var name: String?
//    var countryInfo: String?
    var cases: Double?
    var todayCases: Double?
    var deaths: Double?
    var todayDeaths: Double?
    var recovered: Double?
    var updated: Double?

    enum CodingKeys: String, CodingKey {
        case name = "country"
//        case countryInfo = "countryInfo"
        case cases = "cases"
        case todayCases = "todayCases"
        case deaths = "deaths"
        case todayDeaths = "todayDeaths"
        case recovered = "recovered"
        case updated = "updated"
    }
}
