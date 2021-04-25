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

    /// String where elements are added and the n displayed.
    var stringToCalculate = "" {
        didSet {
            delegate?.displayResult(with: stringToCalculate)
        }
    }

    // MARK: - Checks

    /// Split a string into parts and appened to  elements array.
    private var elements: [String] {
        return stringToCalculate.split(separator: " ").map { "\($0)" }
    }

    /// Checks if the last elements is not an operand then the expression is ready for calculation
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    /// Checks if the elements array contain more than 3 indexes.
    ///
    /// If there are more than 3 elements, a calculation est permissible.
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /// Check If the last element is not an operand, then true can add and operand.
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    /// Check If the first index of the elements to calculate is not an equal sign, then there is no result.
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }

    /// Checks if the string to be calculated contains only a zero.
    ///
    /// Usually the case when app is first launched or the reset button has been tapped.
    private var expressionIsZero: Bool {
        return elements.firstIndex(of: "0") != nil
    }

    /// Checks if the string to be calculated contains a divider operand followed by a zero.
    private var isZeroDivision: Bool {
        if let index = elements.firstIndex(of: "/") {
            if elements[index + 1] == "0" {
                return true
            }
        }
        return false
    }

    // MARK: - Add Data

    /// Reset calculation.
    func resetCalculation() {
        stringToCalculate = "0"
    }

    /// Add number to the string to calculate.
    /// - Parameter number: String value passsed from number button.
    func addNumber(with number: String) {
        if expressionHaveResult {
            resetCalculation()
        }
        if expressionIsZero {
            stringToCalculate = ""
        }
        stringToCalculate.append(number)
    }

    /// Add operand to string to calculate.
    /// - Parameter operand: Title string value of the operand button pressed.
    func addOperand(with operand: String) {
        if canAddOperator {
            stringToCalculate.append(operand)
        } else {
            delegate?.presentAlert(with: .operandAlreadySet)
        }
    }

    /// Add a decimal point to string.
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
        let formattedResult = formatResult(for: Float(result) ?? 0.0)
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
            return "0"
        }
        return operation
    }

    // MARK:  - Result Formatter

    /// Format result displayed to the user. If result is a is whole number then no digiti is displayed.
    /// - Parameter value: Pass in a float value to be converted.
    /// - Returns: Result value converted to a string.
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

