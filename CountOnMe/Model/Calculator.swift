//
//  Calculator.swift
//  CountOnMe
//
//  Created by Birkyboy on 21/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func presentAlert(with error: CountError)
    func displayResult(with result: String)
}

class Calculator {

    // MARK: - Properties
    weak var delegate: CalculatorDelegate?
    private let zeroValue = "0"
    private let decimalSeparator: String = "."

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
    /// Uses space around before and after operand as a separator
    private var elements: [String] {
        return stringToCalculate.split(separator: " ").map { "\($0)" }
    }

    // MARK: - Checks

    /// Checks if the last value of elements array is an operand.
    private var lastElementIsNumber: Bool {
        return elements.last != Operand.add.rawValue &&
            elements.last != Operand.substract.rawValue &&
            elements.last != Operand.multiply.rawValue &&
            elements.last != Operand.divide.rawValue
    }

    /// Checks if the elements array contain more than 3 indexes.
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /// Check If the first index of the elements to calculate is not an equal sign.
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
    /// compare last stringToCalculate element to the first element of the decimalSeparator string.
    private var decimalSeparatorAlreadySet: Bool {
        return stringToCalculate.last == decimalSeparator.first
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

    func addNumber(with number: String) {
        if expressionHaveResult {
            resetCalculation()
        }
        if expressionIsZero {
            stringToCalculate = ""
        }
        stringToCalculate.append(number)
    }

    func addOperand(with operand: String) {
        guard !expressionHaveResult else {
            return error = .resultAlreadyShowing
        }
        guard lastElementIsNumber else {
            return error = .operandAlreadySet
        }
        if stringToCalculate == zeroValue || stringToCalculate == "" {
            return error = .firstIsOperand
        }
        stringToCalculate.append(operand)
    }

    func addDecimalSeparator() {
        guard !expressionHaveResult else {
            return resetCalculation()
        }
        guard !decimalSeparatorAlreadySet else { return }
        stringToCalculate.append(decimalSeparator)
    }

    // MARK: - Calculations

    /// Request a calculation and update the string to calculate with result
    func calculationRequest() {
        guard !expressionHaveResult else {
            return error = .resultAlreadyShowing
        }
        guard lastElementIsNumber,
              expressionHaveEnoughElement,
              !numberAlreadyHasDecimalSeparator else {
            return error = .incorrectExpression
        }
        guard !isZeroDivision else {
            return error = .zeroDivision
        }

        let result = calculateOperation(with: elements)
        if let resultToFloat = Double(result) {
            let formattedResult = resultToFloat.formatResult()
            stringToCalculate.append(" = \(formattedResult)")
        }
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
            var index = 1
            if let operandIndex = operationsToReduce.firstIndex(where: { $0 == Operand.multiply.rawValue || $0 == Operand.divide.rawValue }) {
                index = operandIndex
            }
            let operand = operationsToReduce[index]
            if let left = Double(operationsToReduce[index - 1]),
               let right = Double(operationsToReduce[index + 1]) {
                let result: Double
                switch operand {
                case Operand.add.rawValue      : result = left + right
                case Operand.substract.rawValue: result = left - right
                case Operand.multiply.rawValue : result = left * right
                case Operand.divide.rawValue   : result = left / right
                default: return zeroValue
                }
                // Update the value at operand index - 1 with the result.
                print("\(result.formatResult())")
                print(stringToCalculate)
                operationsToReduce[index - 1] = "\(result)"
                // Remove value after the operand at index + 1.
                operationsToReduce.remove(at: index + 1)
                // Remove the operand at index.
                operationsToReduce.remove(at: index)
            }
        }
        guard let operation = operationsToReduce.first else {
            return zeroValue
        }
        return operation
    }



    func resetCalculation() {
        stringToCalculate = zeroValue
    }
}
