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
        setNeedsStatusBarAppearanceUpdate()
        addLayoutConstraints()

        if !isPasswordSet() {
            solutionLabel.isHidden = true
            messageLabel.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isPasswordSet() {
            let ac = UIAlertController(title: "Instructions", message: Display.pinSetup, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion:nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // Automatically scroll the textView
    // TODO: Not working property. Should scroll to where I'm typing
    override func viewWillLayoutSubviews() {
        let range = NSMakeRange(lastIndexInEquation(), 0)
        equationLabel.scrollRangeToVisible(range)
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

        equationLabel.text = equationLabel.text.replacingOccurrences(of: Math.ans, with: String(finalSolution))
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
                case Math.plus: tempSolution = input1 + input2
                case Math.minus: tempSolution = input1 - input2
                case Math.mul: tempSolution = input1 * input2
                case Math.div: tempSolution = input1 / input2
                case Math.exp: tempSolution = pow(input1,input2)
                default: tempSolution = 0
            }

            equationLabel.text = equationLabel.text.replacingOccurrences(of: equationLabel.text[startPosition ..< endPosition], with: String(tempSolution))
            equationLabel.text = equationLabel.text.replacingOccurrences(of: "e+", with: "e")
        }

        finalSolution = Float(equationLabel.text[0 ..< lastIndexInEquation()])!
        equationLabel.text = equationLabel.text.replacingOccurrences(of: String(finalSolution), with: Math.ans)
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
        return lastStringInEquation() == Math.equal
    }

    private func lastStringInEquation() -> String {
        guard !equationLabel.text.isEmpty else { return "" }
        return String(equationLabel.text.last!)
    }

    private func numberTapped(_ button: String) {
        guard lastStringInEquation() != Math.s else { return }
        if !isPasswordSet() && button == "." { return }
        
        if !equationLabel.text.isEmpty && isEqualAtTheEnd() {
            clearLabel()
        }
        
        equationLabel.text += button
    }

    private func delTapped(_ button: String) {
        guard !equationLabel.text.isEmpty else { return }

        if lastStringInEquation() == Math.s {
            equationLabel.text.removeSubrange(equationLabel.text.index(equationLabel.text.endIndex, offsetBy: -3) ..< equationLabel.text.endIndex)
        } else {
            _ = equationLabel.text.popLast()
        }
    }
    
    @objc private func delHolded() {
        solutionLabel.text = "0"
        equationLabel.text = ""
    }
    
    private func presentStorageVC() {
        let storageVC = StorageVC(title: MediaType.photo.rawValue)
        let navController = UINavigationController(rootViewController: storageVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func negativeTapped(_ button: String) {
        if let password = defaults.string(forKey: "password"), equationLabel.text == password {
            presentStorageVC()
        }

        if !isPasswordSet() && !tempPassword.isEmpty {
            if equationLabel.text == tempPassword {
                defaults.set(tempPassword, forKey: "password")
                defaults.set(true, forKey: "isPasswordSet")
                defaults.synchronize()

                tempPassword = ""
                solutionLabel.isHidden = false
                messageLabel.isHidden = true
                presentStorageVC()
            } else {
                messageLabel.text = Display.mismatch
                tempPassword = ""
                equationLabel.text = ""
                return
            }
        } else if !isPasswordSet() {
            if equationLabel.text.count < 4 {
                messageLabel.text = Display.minCharacters
                equationLabel.text = ""
                return
            } else if equationLabel.text.count > 8 {
                messageLabel.text = Display.maxCharacters
                equationLabel.text = ""
                return
            } else {
                tempPassword = equationLabel.text
                equationLabel.text = ""
                messageLabel.text = Display.confirmPin
                return
            }
        }

        if !equationLabel.text.isEmpty {
            if isEqualAtTheEnd() {
                clearLabel()
                equationLabel.text += Math.negative
            } else if !isInputAnOperator(input: lastStringInEquation(), listOfOperations: numbersIncludeNegative) {
                equationLabel.text += Math.negative
            }
        } else {
            equationLabel.text += Math.negative
        }
    }
    
    private func ansTapped(_ button: String) {
        guard isPasswordSet() else { return }
        if !equationLabel.text.isEmpty {
            if isEqualAtTheEnd() {
                clearLabel()
                equationLabel.text += Math.ans
            } else if !isInputAnOperator(input: lastStringInEquation(), listOfOperations: numbers) {
                equationLabel.text += Math.ans
            }
        } else {
            equationLabel.text += Math.ans
        }
    }

    private func equalTapped(_ button: String) {
        guard isPasswordSet() else { return }
        if !equationLabel.text.isEmpty {
            if isInputAnOperator(input: lastStringInEquation(), listOfOperations: operatorsIncludeNegative) {
                return
            } else {
                equationLabel.text += Math.equal
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
                equationLabel.text += (Math.ans + button)
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
        view.addConstraintsWithFormat("V:|-\(statusBarHeight)-[v0][v1(\(TouchPad.height))]|", views: displayView, collectionView)
        
        displayView.addSubviews(equationLabel, solutionLabel, messageLabel)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: equationLabel)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: solutionLabel)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: messageLabel)
        view.addConstraintsWithFormat("V:|[v0(\(Display.equationLabelHeight))][v1]|", views: equationLabel, solutionLabel)
        view.addConstraintsWithFormat("V:|[v0(\(Display.solutionLabelHeight))][v1]|", views: equationLabel, messageLabel)
    }

}

extension CalculatorVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
        return TouchPad.cellSize
    }
}
