//
//  HelperExtensions.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 15/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

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

extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}

extension UIStackView {
    func addBackground(color: UIColor, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}
