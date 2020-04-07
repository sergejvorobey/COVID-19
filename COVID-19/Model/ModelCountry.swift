//
//  ModelCountry.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 03/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct Root: Decodable {
    let data: [Country]
}

struct Country: Decodable {
    
    var name: String?
    var countryInfo: CountryInfo?
    var cases: Int?
    var todayCases: Int?
    var deaths: Int?
    var todayDeaths: Int?
    var recovered: Int?
    var updated: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "country"
//        case countryInfo = ""
        case cases = "cases"
        case todayCases = "todayCases"
        case deaths = "deaths"
        case todayDeaths = "todayDeaths"
        case recovered = "recovered"
        case updated = "updated"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name )
//        countryInfo = try container.decodeIfPresent(CountryInfo.self, forKey: .countryInfo )
//        cases = try container.decode(Int.self, forKey: .cases )
//        todayCases = try container.decode(Int.self, forKey: .todayCases )
//        deaths = try container.decode(Int.self, forKey: .deaths )
//        todayDeaths = try container.decode(Int.self, forKey: .todayDeaths )
//        recovered = try container.decode(Int.self, forKey: .recovered )
//        updated = try container.decode(Int.self, forKey: .updated )
//        print(name, "\n")
//
//       }
}

struct CountryInfo: Decodable {
    
    var _id: Int?
    var iso2: String?
    var iso3: String?
    var lat: Int?
    var long: Int?
    var flag: String?
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case iso2 = "iso2"
        case iso3 = "iso3"
        case lat = "lat"
        case long = "long"
        case flag = "flag"
        
    }
}
