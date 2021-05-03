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
    private let zeroValue = "0"
    private let decimalSeparator = "."

    /// String containing elements to calculate.
    /// Updates the UI via protocol delagate.
    var stringToCalculate = "" {
        didSet {
            delegate?.displayResult(with: stringToCalculate)
        }
    }

    /// Custom errors, update the UI via protocol delgate if error occurs.
    var error: CountError? {
        didSet {
            guard let error = error else {return}
            delegate?.presentAlert(with: error)
        }
    }

    /// Split string into parts and append to elements array.
    private var elements: [String] {
        return stringToCalculate.split(separator: " ").map { "\($0)" }
    }

    // MARK: - Checks

    /// Checks if the last value of elements array is an operand.
    private var expressionIsCorrect: Bool {
        return elements.last != Operand.add.rawValue &&
            elements.last != Operand.substract.rawValue &&
            elements.last != Operand.multiply.rawValue &&
            elements.last != Operand.divide.rawValue
    }

    /// Checks if the elements array contain more than 3 indexes.
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
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

    /// Checks if a decimal separator is already set for the last number entered
    private var decimalSeparatorAlreadySet: Bool {
        return stringToCalculate.last == "."
    }

    /// Checks if one of the numbers has a two decimal separator
    private var numberAlreadyHasDecimalSeparator: Bool {
        var validity = false
        for index in 0..<elements.count where validity == false {
            validity = elements[index].numberOfOccurrences(of: decimalSeparator) > 1
        }
        return validity
    }

    // MARK: - Add Data

    /// Add number to the string to be calculated.
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

    /// Add operand to string to be calculated.
    /// - Parameter operand: String value of the operand button pressed.
    func addOperand(with operand: String) {
        guard !expressionHaveResult else {
            return error = .resultAlreadyShowing
        }
        guard expressionIsCorrect else {
            return error = .operandAlreadySet
        }
        stringToCalculate.append(operand)
    }

    /// Add a decimal point to string.
    func addDecimalSeparator() {
        guard !expressionHaveResult else {
            return resetCalculation()
        }
        guard !decimalSeparatorAlreadySet else { return }
        stringToCalculate.append(decimalSeparator)
    }


    // MARK: - Calculations

    /// Request a calculation and update the string to calculate with result
    func calculatationRequest() {
        guard !numberAlreadyHasDecimalSeparator else {
            return error = .incorrectExpression
        }
        guard !expressionHaveResult else {
            return error = .resultAlreadyShowing
        }
        guard expressionIsCorrect else {
            return error = .incorrectExpression
        }
        guard expressionHaveEnoughElement else {
            return error = .incorrectExpression
        }
        guard !isZeroDivision else {
            return error = .zeroDivision
        }

        let result = calculateOperation(with: elements)
        if let resultToFloat = Float(result) {
            let formattedResult = resultToFloat.formatResult()
            stringToCalculate.append(" = \(formattedResult)")
        }
    }

    /// Iterate thru array of strings and search for the first index where the operand 'x' or '÷' is present.
    ///
    /// If no 'x' or '÷' operand found, returns default operand index of 1.
    /// - Parameter operationsToReduce: Pass in an array of string to use for calculation.
    /// - Returns: Int index of the operand.
    private func sortCalculationByPriority(for operationsToReduce: [String]) -> Int {
        if let index = operationsToReduce.firstIndex(where: { $0 == Operand.multiply.rawValue || $0 == Operand.divide.rawValue }) {
            return index
        }
        return 1
    }

    /// Iterate thru an array of string to perform calculations.
    ///
    /// Sort Calculation by operand priority, divisions and multiplications are perfomed first.
    /// - Parameter operationsToReduce: Array of strings.
    /// - Returns: Result as a string.
    private func calculateOperation(with operationsToReduce: [String]) -> String {
        // Iterate over operations while an operand present.
        var operationsToReduce = operationsToReduce
        while operationsToReduce.count > 1 {
            let operandIndex = sortCalculationByPriority(for: operationsToReduce)
            let operand = operationsToReduce[operandIndex]
            if let left = Float(operationsToReduce[operandIndex - 1]),
               let right = Float(operationsToReduce[operandIndex + 1]) {
                let result: Float
                switch operand {
                case Operand.add.rawValue      : result = left + right
                case Operand.substract.rawValue: result = left - right
                case Operand.multiply.rawValue : result = left * right
                case Operand.divide.rawValue   : result = left / right
                default: return zeroValue
                }
                // Update the value at operand index - 1 with the result.
                operationsToReduce[operandIndex - 1] = "\(result)"
                // Remove value after the operand at index + 1.
                operationsToReduce.remove(at: operandIndex + 1)
                // Remove the operand at index.
                operationsToReduce.remove(at: operandIndex)
            }
        }
        guard let operation = operationsToReduce.first else {
            return zeroValue
        }
        return operation
    }

    /// Reset calculation by setting the stringToCalculate to zero.
    func resetCalculation() {
        stringToCalculate = zeroValue
    }
}
