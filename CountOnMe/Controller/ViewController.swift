//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    // MARK: Property
    
    private let calculator = Calculator()

    // MARK:  View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }

    // MARK: Actions

    /// Collection of number button actions.
    ///
    /// Button title label value is passed as a number.
    /// - Parameter sender: number button.
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {return}
        calculator.addNumber(with: numberText)
    }

    /// Collection of operand button actions.
    ///
    /// Button title label value is passed as an operand.
    /// - Parameter sender: operand button
    @IBAction func tappedOperandButton(_ sender: UIButton) {
        guard let operandText = sender.title(for: .normal) else {return}
        calculator.addOperand(with: " \(operandText) ")
    }

    /// Button to calculate operation.
    /// - Parameter sender: equal button.
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.calculate()
    }

    /// Resets calculation and display a zero in the textiew.
    /// - Parameter sender: reset button.
    @IBAction func tappedResetButton(_ sender: Any) {
        calculator.resetCalculation()
    }

    /// Adds a decimal point when user wants to make calculations with a decimal value.
    /// - Parameter sender: decimal button.
    @IBAction func tappedDecimalButton(_ sender: Any) {
        calculator.addDecimalPoint()
    }
}

// MARK: - Extension
extension ViewController: CalculatorDelegate {

    /// Display calculation result.
    /// - Parameter result: calculation result as string.
    func displayResult(with result: String) {
        textView.text = result
    }

    /// Present an alert to the user, typically when an error occured.
    /// - Parameter error: custom error from ErrorManager.
    func presentAlert(with error: CountError) {
        let alertVC = UIAlertController(title: "Oups !", message: error.description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
