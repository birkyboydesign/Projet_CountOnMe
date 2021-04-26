//
//  StringExtension.swift
//  CountOnMe
//
//  Created by Birkyboy on 26/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension String {
    public func numberOfOccurrences(_ string: String) -> Int {
        return components(separatedBy: string).count - 1
    }
}
