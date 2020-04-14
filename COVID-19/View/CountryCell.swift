//
//  CountryCell.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 03/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var todayCases: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var todayDeaths: UILabel!
    @IBOutlet weak var recovered: UILabel!
    @IBOutlet weak var timeUpdate: UILabel!
}
