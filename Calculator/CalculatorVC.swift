//
//  ViewController.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/8/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import AVFoundation
import UIKit

class CalculatorVC: UIViewController {
    
    private enum Message: String {
        case minCharacters = "Minimum 4 characters"
        case maxCharacters = "Maximum 8 characters"
        case confirmPin = "Confirm your pin"
        case pinSetup = "Select a pin and press the (-) button to continue.\n \n Once set up, you will use the (-) to unlock your secret vault"
        case mismatch = "Mismatch. Reset password"
    }

    private enum Math: String {
        case ans = "ANS"
        case negative = "-"
        case minus = "−"
        case s = "S"
        case equal = "="
        case plus = "+"
        case mul = "×"
        case div = "÷"
        case exp = "^"
    }

    @IBOutlet weak var equationLabel: UITextView!
    @IBOutlet weak var solutionLabel: UILabel!
    @IBOutlet weak var pinMessageLabel: UILabel!
    
    @IBOutlet weak var divison: UIButton!
    @IBOutlet weak var multiplication: UIButton!
    @IBOutlet weak var subtraction: UIButton!
    @IBOutlet weak var addition: UIButton!
    @IBOutlet weak var equal: UIButton!
    @IBOutlet weak var negative: UIButton!
    
    private var finalSolution: Float = 0
    private var tempSolution: Float = 0
    private var tempPassword = ""
    
    private let defaults = UserDefaults.standard
    
    private let numbers = [".","0","1","2","3","4","5","6","7","8","9", "S"]
    private let numbersIncludeNegative = ["-",".","0","1","2","3","4","5","6","7","8","9", "S"] // first one is negative
    private let operators = ["=","+","−","×","÷","^"]
    private let operatorsIncludeNegative = ["=","+","−","×","÷","^","-"] // last one is negative
    private let operatorsExcludeEqual = ["+","−","×","÷"]
    private let operatorsIncludeExponentExcludeEqual = ["+","−","×","÷","^"]
    private let higherOrderOperation = ["×","÷"]
    private let lowerOrderOperation = ["+","−","="]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isPasswordSet() {
            solutionLabel.isHidden = true
            pinMessageLabel.isHidden = false
            negative.layer.borderWidth = 3
            negative.layer.borderColor = UIColor.orange.cgColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isPasswordSet() {
            let ac = UIAlertController(title: "Instructions", message: Message.pinSetup.rawValue, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion:nil)
        }
    }
    
    // Automatically scroll the textView
    // TODO: Not working property. Should scroll to where I'm typing
    override func viewWillLayoutSubviews() {
        let range = NSMakeRange(lastIndexInEquation(), 0)
        equationLabel.scrollRangeToVisible(range)
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        guard lastStringInEquation() != Math.s.rawValue else { return }
        if !isPasswordSet() && sender.currentTitle == "." { return }

        if !equationLabel.text.isEmpty && isEqualAtTheEnd() {
            clearLabel()
        }
        
        equationLabel.text += sender.currentTitle!
    }

    @IBAction func DELTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        guard !equationLabel.text.isEmpty else { return }

        if lastStringInEquation() == Math.s.rawValue {
            equationLabel.text.removeSubrange(equationLabel.text.index(equationLabel.text.endIndex, offsetBy: -3) ..< equationLabel.text.endIndex)
        } else {
            _ = equationLabel.text.popLast()
        }
    }
    
    @IBAction func DELHolded(_ sender: Any) {
        solutionLabel.text = "0"
        equationLabel.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationNC = segue.destination as? UINavigationController {
            if let storageVC = destinationNC.viewControllers.first as? StorageVC {
                if let titleName = sender as? String {
                    storageVC.titleName = titleName
                }
            }
        }
    }
    
    @IBAction func negativeTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        if let password = defaults.string(forKey: "password"), equationLabel.text == password {
            performSegue(withIdentifier: "toStorageVC", sender: "Photo")
        }
        
        if !isPasswordSet() && !tempPassword.isEmpty {
            if equationLabel.text == tempPassword {
                defaults.set(tempPassword, forKey: "password")
                defaults.set(true, forKey: "isPasswordSet")
                defaults.synchronize()
                
                tempPassword = ""
                solutionLabel.isHidden = false
                pinMessageLabel.isHidden = true
                performSegue(withIdentifier: "toStorageVC", sender: nil)
            } else {
                pinMessageLabel.text = Message.mismatch.rawValue
                tempPassword = ""
                equationLabel.text = ""
                return
            }
        } else if !isPasswordSet() {
            if equationLabel.text.count < 4 {
                pinMessageLabel.text = Message.minCharacters.rawValue
                equationLabel.text = ""
                return
            } else if equationLabel.text.count > 8 {
                pinMessageLabel.text = Message.maxCharacters.rawValue
                equationLabel.text = ""
                return
            } else {
                tempPassword = equationLabel.text
                equationLabel.text = ""
                pinMessageLabel.text = Message.confirmPin.rawValue
                return
            }
        }
        
        if !equationLabel.text.isEmpty {
            if isEqualAtTheEnd() {
                clearLabel()
                equationLabel.text += Math.negative.rawValue
            } else if !isInputAnOperator(input: lastStringInEquation(), listOfOperations: numbersIncludeNegative) {
                equationLabel.text += Math.negative.rawValue
            }
        } else {
            equationLabel.text += Math.negative.rawValue
        }
    }
    
    @IBAction func ANSTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        guard isPasswordSet() else { return }
        if !equationLabel.text.isEmpty {
            if isEqualAtTheEnd() {
                clearLabel()
                equationLabel.text += Math.ans.rawValue
            } else if !isInputAnOperator(input: lastStringInEquation(), listOfOperations: numbers) {
                equationLabel.text += Math.ans.rawValue
            }
        } else {
            equationLabel.text += Math.ans.rawValue
        }
    }
    
    @IBAction func performOperator(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        guard isPasswordSet() else { return }
        if equationLabel.text != "" {
            if !isInputAnOperator(input: lastStringInEquation(), listOfOperations: operatorsIncludeNegative) {
                equationLabel.text += sender.currentTitle!
            }
            if isEqualAtTheEnd() {
                clearLabel()
                equationLabel.text += (Math.ans.rawValue + sender.currentTitle!)
            }
        }
    }
    
    @IBAction func equalTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        guard isPasswordSet() else { return }
        if !equationLabel.text.isEmpty {
            if isInputAnOperator(input: lastStringInEquation(), listOfOperations: operatorsIncludeNegative) {
                return
            } else {
                equationLabel.text += Math.equal.rawValue
                solutionLabel.text = formatOutput(convert: String(calculate()))
            }
        }
    }
    
    private func clearLabel() {
        if equationLabel.text.isEmpty {
            solutionLabel.text = ""
        } else {
            equationLabel.text = ""
        }
    }
    
    private func isInputAnOperator(input: String, listOfOperations: [String]) -> Bool {
        for character in input {
            for operation in listOfOperations {
                if String(character) == operation {
                    return true
                }
            }
        }
        return false
    }

    private func calculate() -> Float {
        var input1: Float!
        var input2: Float!
        var operatorPosition: Int!
        var startPosition: Int!
        var endPosition: Int!
        var operation = "A"
        var listToBeNotIn = [String]()
        var listToBeIn = [String]()
        
        equationLabel.text = equationLabel.text.replacingOccurrences(of: Math.ans.rawValue, with: String(finalSolution))
        equationLabel.text = equationLabel.text.replacingOccurrences(of: "e+", with: String("e"))
        equationLabel.text = equationLabel.text.replacingOccurrences(of: "--", with: String(""))
        
        //loop to read the string of operations
        while isInputAnOperator(input: equationLabel.text, listOfOperations: operatorsIncludeExponentExcludeEqual) {
            
            startPosition = 0
            
            //Determines order of operation
            if isInputAnOperator(input: equationLabel.text, listOfOperations: ["^"]) {
                listToBeNotIn = operatorsExcludeEqual
                listToBeIn = ["^"]
                
            } else if isInputAnOperator(input: equationLabel.text, listOfOperations: higherOrderOperation) {
                //Cases with higher precedence
                
                listToBeNotIn = lowerOrderOperation
                listToBeIn = higherOrderOperation
            } else {
                listToBeNotIn = [""]
                listToBeIn = lowerOrderOperation
            }
            
            //Main 2 loops that determine inputs
            for i in 0 ..< equationLabel.text.count {
                if isInputAnOperator(input: equationLabel.text[i], listOfOperations: listToBeNotIn) {
                    startPosition = i + 1
                }

                if isInputAnOperator(input: String(equationLabel.text[i]), listOfOperations: listToBeIn) {
                    input1 = Float(equationLabel.text[startPosition ..< i])
                    operation = equationLabel.text[i]
                    operatorPosition = i + 1
                    break
                }
            }
            
            for j in operatorPosition ..< equationLabel.text.count {
                if isInputAnOperator(input: equationLabel.text[j], listOfOperations: operators) {
                    input2 = Float(equationLabel.text[operatorPosition..<j])
                    endPosition = j
                    break
                }
            }
            
            switch operation {
                case Math.plus.rawValue: tempSolution = input1 + input2
                case Math.minus.rawValue: tempSolution = input1 - input2
                case Math.mul.rawValue: tempSolution = input1 * input2
                case Math.div.rawValue: tempSolution = input1 / input2
                case Math.exp.rawValue: tempSolution = pow(input1,input2)
                default: tempSolution = 0
            }
            
            equationLabel.text = equationLabel.text.replacingOccurrences(of: equationLabel.text[startPosition ..< endPosition], with: String(tempSolution))
            equationLabel.text = equationLabel.text.replacingOccurrences(of: "e+", with: "e")
            print(equationLabel)
        }
        
        finalSolution = Float(equationLabel.text[0 ..< lastIndexInEquation()])!
        equationLabel.text = equationLabel.text.replacingOccurrences(of: String(finalSolution), with: Math.ans.rawValue)
        return finalSolution
    }
    
    private func formatOutput(convert value: String!) -> String {
        guard value != nil else { return "0" }
        let doubleValue = Double(value) ?? 0.0
        let formatter = NumberFormatter()
        
        if value.count > 8 {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 3
        }
        
        return formatter.string(from: NSNumber(value: doubleValue))!
    }
    
    private func lastIndexInEquation() -> Int {
        return equationLabel.text.count - 1
    }
    
    private func isPasswordSet() -> Bool {
        return defaults.bool(forKey: "isPasswordSet")
    }

    private func isEqualAtTheEnd() -> Bool {
        return lastStringInEquation() == Math.equal.rawValue
    }

    private func lastStringInEquation() -> String {
        guard !equationLabel.text.isEmpty else { return "" }
        return String(equationLabel.text.last!)
    }
    
}

