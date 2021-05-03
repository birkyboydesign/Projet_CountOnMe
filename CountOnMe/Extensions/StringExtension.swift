//
//  StringExtension.swift
//  CountOnMe
//
//  Created by Birkyboy on 26/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension String {

    /// Count how many time a character is present in a string.
    /// - Parameter string: Pass in the number string to check.
    /// - Returns: Number of decimal separator present.
    public func numberOfOccurrences(of character: String) -> Int {
        return components(separatedBy: character).count - 1
    }

}
