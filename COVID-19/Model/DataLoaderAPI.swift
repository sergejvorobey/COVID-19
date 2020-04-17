//
//  Service.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 04/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Alamofire

class DataLoaderAPI {
    
//    fileprivate var baseURL = "https://corona.lmao.ninja/countries/"
    fileprivate var baseURL = "https://corona.lmao.ninja/v2/countries/"

    typealias countriesCallBack = (_ countries:[Country]?, _ status: Bool, _ message:String) -> Void
   
    var callBack: countriesCallBack?

    func getAllCountryName() {
        AF.request(self.baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseData {(responseData) in
            
            guard let data = responseData.data else {return}
            self.callBack?(nil, false, "")

            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                self.callBack?(countries, true,"")
//                print(countries)
            }
            
            catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping countriesCallBack) {
        self.callBack = callBack
    }
}
