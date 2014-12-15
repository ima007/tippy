//
//  Extensions.swift
//  tips
//
//  Created by Shane Afsar on 12/14/14.
//  Copyright (c) 2014 safsar. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var asDoubleValue: Double {
        return (self as NSString).doubleValue
    }
}

extension Double {
    var asCurrency: String{
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = SettingsStore().localeTest
        return formatter.stringFromNumber(self)!
    }
}

extension UIView {
    //Loop through and update all UILabel children
    func updateViewLabels(color: UIColor){
        for ui in self.subviews {
            if ui is UILabel{
                var label = ui as UILabel
                label.textColor = color
            }
        }
    }
}