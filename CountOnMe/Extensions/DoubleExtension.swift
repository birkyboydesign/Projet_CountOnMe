//
//  Extension.swift
//  CountOnMe
//
//  Created by Birkyboy on 25/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation


extension Double {
    // MARK:  - Result Formatter

    /// Format result displayed to the user. If result is a is whole number then no digiti is displayed.
    /// - Parameter value: Pass in a float value to be converted.
    /// - Returns: Result value converted to a string.
    func formatResult() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
}
