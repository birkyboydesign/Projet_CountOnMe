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

    private let calculator = Calculator()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }

    // MARK: - Actions

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {return}
        calculator.addNumber(with: numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        guard let operandText = sender.title(for: .normal) else {return}
        calculator.addOperand(with: " \(operandText) ")
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.calculate()
    }

    @IBAction func tappedResetButton(_ sender: Any) {
        calculator.resetCalculation()
    }

    @IBAction func tappedDecimalButton(_ sender: Any) {
        calculator.addDecimalPoint()
    }
}

extension ViewController: CalculatorDelegate {

    // MARK: - Result Display
    /// Display calculation result
    /// - Parameter result: calculation result as string
    func displayResult(with result: String) {
        textView.text = result
    }

    // MARK: - Alert
    func presentAlert(with error: CountError) {
        let alertVC = UIAlertController(title: "Oups !", message: error.description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
