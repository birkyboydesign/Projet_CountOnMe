//
//  Calculator.swift
//  CountOnMe
//
//  Created by Birkyboy on 21/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import SwiftUI

enum Operand: String {
    case add = " + "
    case substract = " - "
    case multiply = " x "
    case divide = " / "
}

protocol CalculatorDelegate: AnyObject {
    func presentAlert(with error: CountError)
    func displayResult(with result: String)
}

class Calculator {

    // MARK: - Properties
    weak var delegate: CalculatorDelegate?

    var stringToCalculate = "" {
        didSet {
            delegate?.displayResult(with: stringToCalculate)
        }
    }

    // MARK: Error Checks

    /// Split a string in to parts contain in the array elements
    private var elements: [String] {
        return stringToCalculate.split(separator: " ").map { "\($0)" }
    }

    /// if the last elements is not and operand then the expression is correct and ready for calculation
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    /// if there are at least 3 elements, the nthere are enough elements to calculate a result
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /// If the last element is not an operand, then true can add and operand
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    /// If the first index of the elements to calculate is NOT an equal sign, there is no result
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }

    /// reset calculation
    func resetCalculation() {
        stringToCalculate = ""
    }

    func addNumber(with number: String) {
        if expressionHaveResult {
            resetCalculation()
        }
        stringToCalculate.append(number)
    }

    func addOperand(with operand: Operand) {
        if canAddOperator {
            stringToCalculate.append(operand.rawValue)
        } else {
            delegate?.presentAlert(with: .operandAlreadySet)
        }
    }

    func addDecimalPoint() {
        if expressionHaveResult {
            resetCalculation()
        }
        stringToCalculate.append(".")
    }

    func calculate() {
        guard expressionIsCorrect else {
            delegate?.presentAlert(with: .incorrectExpression)
            return
        }
        guard expressionHaveEnoughElement else {
            delegate?.presentAlert(with: .startNewCalculation)
            return
        }
        let result = calculateOperation(with: elements)
        stringToCalculate.append(" = \(result)")
    }

    private func calculateOperation(with operationsToReduce: [String]) -> String {
        // Iterate over operations while an operand still here
        var operationsToReduce = operationsToReduce
        while operationsToReduce.count > 1 {
            let left = Float(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Float(operationsToReduce[2])!
            
            let result: Float
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case "/": result = left / right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        guard let operation = operationsToReduce.first else {return ""}
        return operation
    }
    
}
