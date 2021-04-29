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

enum Operand: String {
    case add       = "+"
    case multiply  = "x"
    case divide    = "/"
    case substract = "-"
    case equal     = "="
}

class Calculator {

    // MARK: - Properties

    weak var delegate: CalculatorDelegate?
    private let zeroValue = "0"
    private let decimalSeparator = "."

    /// String where elements are added and the n displayed.
    var stringToCalculate = "" {
        didSet {
            delegate?.displayResult(with: stringToCalculate)
        }
    }

    var error: CountError? {
        didSet {
            guard let error = error else {return}
            delegate?.presentAlert(with: error)
        }
    }

    /// Split a string into parts and appened to  elements array.
    private var elements: [String] {
        return stringToCalculate.split(separator: " ").map { "\($0)" }
    }

    // MARK: - Checks

    /// Checks if the last elements is not an operand then the expression is ready for calculation
    private var expressionIsCorrect: Bool {
        return elements.last != Operand.add.rawValue &&
            elements.last != Operand.substract.rawValue &&
            elements.last != Operand.multiply.rawValue &&
            elements.last != Operand.divide.rawValue
    }

    /// Checks if the elements array contain more than 3 indexes.
    /// If there are more than 3 elements, a calculation est permissible.
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /// Check If the last element is not an operand, then true can add and operand.
    private var canAddOperator: Bool {
        return elements.last != Operand.add.rawValue &&
            elements.last != Operand.substract.rawValue &&
            elements.last != Operand.multiply.rawValue &&
            elements.last != Operand.divide.rawValue
    }

    /// Check If the first index of the elements to calculate is not an equal sign, then there is no result.
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: Operand.equal.rawValue) != nil
    }

    /// Checks if the string to be calculated contains  a zero.
    /// Usually the case when app is first launched or the reset button has been tapped.
    private var expressionIsZero: Bool {
        return elements.firstIndex(of: zeroValue) != nil
    }

    /// Checks if the string to be calculated contains a divider operand followed by a zero.
    private var isZeroDivision: Bool {
        if let index = elements.firstIndex(of: Operand.divide.rawValue) {
            if elements[index + 1] == zeroValue {
                return true
            }
        }
        return false
    }

    // MARK: Decimal seprator checks

    /// Checks if a decimal separator is already set for the last number entered
    private var decimalSeparatorAlreadySet: Bool {
        return stringToCalculate.last == "."
    }

    /// Checks if one of the numbers has a two decimal separator
    private var numberAlreadyHasDecimalSeparator: Bool {
        var validity = false
        for index in 0..<elements.count where validity == false {
            validity = elements[index].numberOfOccurrences(".") > 1
        }
        return validity
    }
    // MARK: - Reset

    /// Reset calculation.
    func resetCalculation() {
        stringToCalculate = zeroValue
    }

    // MARK: - Add Data

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
        guard expressionHaveResult == false else {
            error = .resultAlreadyShowing
            return
        }
        guard canAddOperator else {
            error = .operandAlreadySet
            return
        }
        stringToCalculate.append(operand)
    }

    /// Add a decimal point to string.
    func addDecimalSeparator() {
        guard expressionHaveResult == false else {
            resetCalculation()
            return
        }
        guard decimalSeparatorAlreadySet == false else {
            return
        }
        stringToCalculate.append(decimalSeparator)
    }


    // MARK: - Calculations

    func calculate() {
        if numberAlreadyHasDecimalSeparator {
            error = .incorrectExpression
            return
        }
        if expressionHaveResult {
            error = .resultAlreadyShowing
            return
        }
        guard expressionIsCorrect else {
            error = .incorrectExpression
            return
        }
        guard expressionHaveEnoughElement else {
            error = .incorrectExpression
            return
        }
        guard !isZeroDivision else {
            error = .zeroDivision
            return
        }

        let result = calculateOperation(with: elements)
        if let resultToFloat = Float(result) {
            let formattedResult = resultToFloat.formatResult()
            stringToCalculate.append(" = \(formattedResult)")
        }
    }

    /// Sorts calculation by operand priorites.
    /// look for the the first index where the operand x or / is present
    /// - Parameter elements: Pass in an array of string to use for calculation
    /// - Returns: index of the operand
    private func sortCalculationByPriority(for elements: [String]) -> Int {
        if let index = elements.firstIndex(where: { $0 == Operand.multiply.rawValue ||
                                                $0 == Operand.divide.rawValue }) {
            return index
        }
        return 1
    }

    private func calculateOperation(with operationsToReduce: [String]) -> String {
        // Iterate over operations while an operand still here
        var operationsToReduce = operationsToReduce
        while operationsToReduce.count > 1 {
            // Set the index in operand priority
            let index = sortCalculationByPriority(for: operationsToReduce)
            let operand = operationsToReduce[index]
            if let left = Float(operationsToReduce[index - 1]),
               let right = Float(operationsToReduce[index + 1]) {
                let result: Float
                switch operand {
                case Operand.add.rawValue      : result = left + right
                case Operand.substract.rawValue: result = left - right
                case Operand.multiply.rawValue : result = left * right
                case Operand.divide.rawValue   : result = left / right
                default: return zeroValue
                }
                // replace the value at index before the operand with result
                operationsToReduce[index - 1] = "\(result)"
                // remove value after the operand
                operationsToReduce.remove(at: index + 1)
                // remove the operand
                operationsToReduce.remove(at: index)
            }
        }
        guard let operation = operationsToReduce.first else {
            return zeroValue
        }
        return operation
    }

}

