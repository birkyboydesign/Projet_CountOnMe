//
//  ErrorManager.swift
//  CountOnMe
//
//  Created by Birkyboy on 21/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum CountError: Error {
    case operandAlreadySet
    case incorrectExpression
    case startNewCalculation
    
}

extension CountError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .operandAlreadySet:
            return "Un operateur est déja mis !"
        case .incorrectExpression:
            return "Entrez une expression correcte !"
        case .startNewCalculation:
            return "Démarrez un nouveau calcul !"
        }
    }
}
