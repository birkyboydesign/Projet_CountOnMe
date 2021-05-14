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

    // MARK: - Property

    private let calculator = Calculator()

    // MARK:  - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }


    // MARK: - Actions

    /// Collection of number button actions.
    /// Button title label string value is passed to the model.
    /// - Parameter sender: number button.
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {return}
        calculator.addNumber(with: numberText)
    }

    /// Collection of operand button actions.
    /// Button title label  string value is passed to the model.
    /// - Parameter sender: operand button
    @IBAction func tappedOperandButton(_ sender: UIButton) {
        guard let operandText = sender.title(for: .normal) else {return}
        calculator.addOperand(with: " \(operandText) ")
    }

    /// Button action to calculate operation.
    /// - Parameter sender: Equal button.
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.calculationRequest()
    }

    /// Reset button action.
    /// - Parameter sender: Reset button.
    @IBAction func tappedResetButton(_ sender: Any) {
        calculator.resetCalculation()
    }

    /// Decimal button action.
    /// - Parameter sender: Decimal button.
    @IBAction func tappedDecimalButton(_ sender: Any) {
        calculator.addDecimalSeparator()
    }
}

// MARK: - Extension
extension ViewController: CalculatorDelegate {

    func displayResult(with result: String) {
            self.textView.text = result
    }

    func presentAlert(with error: CountError) {
        let alertVC = UIAlertController(title: "Oups!",
                                        message: error.description,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK",
                                        style: .cancel,
                                        handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
