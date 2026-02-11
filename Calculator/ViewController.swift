//
//  ViewController.swift
//  Calculator
//
//  Created by Sanyukta Adhate on 09/02/26.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var operationLabel: UILabel!
    
    //MARK: - X
    @IBAction func deleteLeft(_ sender: UIButton) {
        //typing num? Yes then dont erase.
        guard isTypingNumber else { return }
        if let text = displayLabel.text, text.count > 1 {
            displayLabel.text?.removeLast()
        }
        else{
            //7 is last digit after removed set it to 0
            displayLabel.text = "0"
            isTypingNumber = false
        }
        currentNumber = Double(displayLabel.text!) ?? 0
    }
    
    //MARK: - %
    @IBAction func percentage(_ sender: UIButton) {
        currentNumber = currentNumber / 100
        displayLabel.text = format(currentNumber)
    }
    
    //MARK: - Plus/Minus
    @IBAction func togglePressed(_ sender: UIButton) {
        currentNumber *= -1
        displayLabel.text = format(currentNumber)
    }
    
    //MARK: - AC
    @IBAction func clearPressed(_ sender: UIButton) {
        displayLabel.text = "0"
        currentNumber = 0
        previousNumber = 0
        operation = nil
        isTypingNumber = false
        operationLabel.text = ""
        operationLb = ""
    }
    
    //MARK: - + - * /
    @IBAction func operationPressed(_ sender: UIButton) {
        if operation != nil && isTypingNumber {
            calculate()
        }
        
        previousNumber = currentNumber
        guard let symbol = sender.currentTitle else { return }
        switch symbol {
            case "+":
                operation = .add
            case "-":
                operation = .subtract
            case "×":
                operation = .multiply
            case "÷":
                operation = .divide
            default:
                break
        }
        operationLb = "\(format(previousNumber)) \(symbol)"
        operationLabel.text = operationLb
        isTypingNumber = false
    }
    
    //MARK: - 0-9
    @IBAction func numberPressed(_ sender: UIButton) {
        guard let number = sender.currentTitle else { return }
        if isTypingNumber {
            //Next digits append
            displayLabel.text = (displayLabel.text ?? "") + number
        }
        else{
            //First digit replaces 0
            displayLabel.text = number
            isTypingNumber = true
        }
        currentNumber = Double(displayLabel.text!) ?? 0
        
        if operation != nil {
            operationLabel.text = "\(operationLb) \(displayLabel.text!)"
        }
    }
    
    //MARK: - .
    @IBAction func decimalPressed(_ sender: Any) {
        if !isTypingNumber {
            displayLabel.text = "0."
            isTypingNumber = true
            return
        }
        if !(displayLabel.text?.contains(".") ?? false) {
            displayLabel.text?.append(".")
        }
    }
    
    //MARK: - =
    @IBAction func equalsPressed(_ sender: UIButton) {
        calculate()
        operation = nil
        operationLabel.text = ""
        operationLb = ""
    }
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayLabel.text = "0"
        operationLabel.text = ""
    }
    
    var currentNumber: Double = 0
    var previousNumber: Double = 0
    var operation: Operation? = nil
    var isTypingNumber = false
    var operationLb = ""
    enum Operation {
        case add, subtract, multiply, divide
    }
    
    func format(_ num: Double) -> String {
            //check the decimal part of number if it is 0 INT else show as it is
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(num))
        }
        return String(num)
    }
    
    func calculate(){
        guard let operation = operation else { return }

        let previous = previousNumber
        let current = currentNumber

        var result: Double = 0

        switch operation {
            case .add:
                result = previous + current
            case .subtract:
                result = previous - current
            case .multiply:
                result = previous * current
            case .divide:
                // Handle division by zero
                guard current != 0 else {
                    displayLabel.text = "Error"
                    currentNumber = 0
                    isTypingNumber = false
                    return
                }
                result = previous / current
        }
        currentNumber = result
        displayLabel.text = format(result)
        isTypingNumber = false
    }
}

