//
//  StringExtension.swift
//  CountOnMe
//
//  Created by Birkyboy on 26/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension String {

    /// This extension is used to count if the decimal separator is present several times in an element.
    /// - Parameter string: Pass in the number string to check.
    /// - Returns: Number of decimal separator present.
    public func numberOfOccurrences(_ string: String) -> Int {
        return components(separatedBy: string).count - 1
    }

}
