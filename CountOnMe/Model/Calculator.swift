//
//  Calculator.swift
//  CountOnMe
//
//  Created by Birkyboy on 21/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import SwiftUI

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

    // MARK: - Checks

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

    private var expressionIsZero: Bool {
        return elements.firstIndex(of: "0") != nil
    }

    private var isZeroDivision: Bool {
        if let index = elements.firstIndex(of: "/") {
            if elements[index + 1] == "0" {
                return true
            }
        }
        return false
    }

    // MARK: - Add Data

    /// reset calculation
    func resetCalculation() {
        stringToCalculate = "0"
    }

    /// Add number to the string to calculate
    /// - Parameter number: String value passsed from number Button
    func addNumber(with number: String) {
        if expressionHaveResult {
            resetCalculation()
        }
        if expressionIsZero {
            stringToCalculate = ""
        }
        stringToCalculate.append(number)
    }

    /// Add operand to string to calculate
    /// - Parameter operand: Openrand enum raw value
    func addOperand(with operand:String) {
        if canAddOperator {
            stringToCalculate.append(operand)
        } else {
            delegate?.presentAlert(with: .operandAlreadySet)
        }
    }

    /// Add a decimal point to string to calculate
    func addDecimalPoint() {
        if expressionHaveResult {
            resetCalculation()
        }
        stringToCalculate.append(".")
    }


// MARK: - Calculations

    func calculate() {
        if expressionHaveResult {
            resetCalculation()
            return
        }
        guard expressionIsCorrect else {
            delegate?.presentAlert(with: .incorrectExpression)
            return
        }
        guard expressionHaveEnoughElement else {
            delegate?.presentAlert(with: .startNewCalculation)
            return
        }
        guard !isZeroDivision else {
            delegate?.presentAlert(with: .zeroDivision)
            resetCalculation()
            return
        }
        let result = calculateOperation(with: elements)
        let formattedResult = formatResult(for: Float(result) ?? 0)
        stringToCalculate.append(" = \(formattedResult)")
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
            default: result = 0.0
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        guard let operation = operationsToReduce.first else {
            return ""
        }
        return operation
    }

    // MARK:  - Result Formatter

    /// Format result displayed to the user. If result is a is whole number then no digiti is displayed.
    /// - Parameter value: Pass in a float value to be converted.
    /// - Returns: Result value converted to a string
    private func formatResult(for value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""
        let number = NSNumber(value: value)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
}

