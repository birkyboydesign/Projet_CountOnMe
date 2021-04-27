//
//  ErrorManager.swift
//  CountOnMe
//
//  Created by Birkyboy on 21/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

/// Custom Errors.
enum CountError: LocalizedError {
    case operandAlreadySet
    case incorrectExpression
    case zeroDivision
    case resultAlreadyShowing

     var description: String {
        switch self {
        case .operandAlreadySet:
            return "Un operateur est déja mis !"
        case .incorrectExpression:
            return "Entrez une expression correcte !"
        case .zeroDivision:
            return "Division par zéro impossible !"
        case .resultAlreadyShowing:
            return "Le resultat est déja affiché !"
        }
    }
}
