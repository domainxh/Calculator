//
//  ViewController.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/8/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import AVFoundation
import UIKit

let statusBarHeight = UIApplication.shared.statusBarFrame.height
let displayViewHeight = (UIScreen.main.bounds.height - statusBarHeight) * 0.33
let solutionLabelHeight = displayViewHeight * 0.6
let equationLabelHeight = displayViewHeight * 0.4

let collectionViewSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - statusBarHeight - displayViewHeight)

let cellPerRow: CGFloat = 4
let cellPerColumn: CGFloat = 5
let cellWidth = collectionViewSize.width / cellPerRow
let cellHeight = collectionViewSize.height / cellPerColumn
let cellSize = CGSize(width: cellWidth, height: cellHeight)

class CalculatorVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

    private let buttons = [
        "DEL", "^", "(-)", "÷",
        "7", "8", "9", "×",
        "4", "5", "6", "−",
        "1", "2", "3", "+",
        "0", ".", "ANS", "="
    ]
    
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

        view.backgroundColor = .white
        addLayoutConstraints()

        if !isPasswordSet() {
            solutionLabel.isHidden = true
            messageLabel.isHidden = false
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationNC = segue.destination as? UINavigationController {
            if let storageVC = destinationNC.viewControllers.first as? StorageVC {
                if let titleName = sender as? String {
                    storageVC.titleName = titleName
                }
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

    private func numberTapped(_ button: String) {
        guard lastStringInEquation() != Math.s.rawValue else { return }
        if !isPasswordSet() && button == "." { return }
        
        if !equationLabel.text.isEmpty && isEqualAtTheEnd() {
            clearLabel()
        }
        
        equationLabel.text += button
    }

    private func delTapped(_ button: String) {
        guard !equationLabel.text.isEmpty else { return }

        if lastStringInEquation() == Math.s.rawValue {
            equationLabel.text.removeSubrange(equationLabel.text.index(equationLabel.text.endIndex, offsetBy: -3) ..< equationLabel.text.endIndex)
        } else {
            _ = equationLabel.text.popLast()
        }
    }
    
    @objc private func delHolded() {
        solutionLabel.text = "0"
        equationLabel.text = ""
    }
    
    private func negativeTapped(_ button: String) {
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
                messageLabel.isHidden = true
                performSegue(withIdentifier: "toStorageVC", sender: nil)
            } else {
                messageLabel.text = Message.mismatch.rawValue
                tempPassword = ""
                equationLabel.text = ""
                return
            }
        } else if !isPasswordSet() {
            if equationLabel.text.count < 4 {
                messageLabel.text = Message.minCharacters.rawValue
                equationLabel.text = ""
                return
            } else if equationLabel.text.count > 8 {
                messageLabel.text = Message.maxCharacters.rawValue
                equationLabel.text = ""
                return
            } else {
                tempPassword = equationLabel.text
                equationLabel.text = ""
                messageLabel.text = Message.confirmPin.rawValue
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
    
    private func ansTapped(_ button: String) {
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
    
    private func equalTapped(_ button: String) {
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

    private func performOperator(_ button: String) {
        guard isPasswordSet() else { return }
        if equationLabel.text != "" {
            if !isInputAnOperator(input: lastStringInEquation(), listOfOperations: operatorsIncludeNegative) {
                equationLabel.text += button
            }
            if isEqualAtTheEnd() {
                clearLabel()
                equationLabel.text += (Math.ans.rawValue + button)
            }
        }
    }
    
    private let displayView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    private let equationLabel: UITextView = {
        let view = UITextView()
        view.text = ""
        view.backgroundColor = .orange
        view.textAlignment = .left
        view.font = UIFont(name: "AvenirNext-Regular", size: 25)
        return view
    }()
    
    private let solutionLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.backgroundColor = .red
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-Regular", size: 50)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Create a PIN for this device"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "AvenirNext-Regular", size: 25)
        label.isHidden = true
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.layer.borderColor = UIColor.purple.cgColor
        cv.layer.borderWidth = 5
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        return cv
    }()
    
    private func addLayoutConstraints() {
        view.addSubviews(displayView, collectionView)
        view.addConstraintsWithFormat("H:|[v0]|", views: displayView)
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|-\(statusBarHeight)-[v0][v1(\(collectionViewSize.height))]|", views: displayView, collectionView)
        
        displayView.addSubviews(equationLabel, solutionLabel, messageLabel)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: equationLabel)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: solutionLabel)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: messageLabel)
        view.addConstraintsWithFormat("V:|[v0(\(equationLabelHeight))][v1]|", views: equationLabel, solutionLabel)
        view.addConstraintsWithFormat("V:|[v0(\(equationLabelHeight))][v1]|", views: equationLabel, messageLabel)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(buttons[indexPath.item], isPasswordSet())
        
        if buttons[indexPath.item] == "DEL" {
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(delHolded))
            cell.addGestureRecognizer(gesture)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonText = buttons[indexPath.item]
        AudioServicesPlaySystemSound(1104)
        switch buttonText {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".":
            numberTapped(buttonText)
        case "DEL":
            delTapped(buttonText)
        case "=":
            equalTapped(buttonText)
        case "(-)":
            negativeTapped(buttonText)
        case "ANS":
            ansTapped(buttonText)
        case "+", "−", "×", "÷", "^":
            performOperator(buttonText)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
