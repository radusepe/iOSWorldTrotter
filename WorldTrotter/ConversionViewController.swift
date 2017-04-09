//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Radu Sepetan on 2017-04-07.
//  Copyright © 2017 Radu Sepetan. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    let digits: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "-"]
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let hour = Calendar.current.component(.hour, from: Date())
        let day = hour > 5 && hour < 20
        if day == false {
            self.view.backgroundColor = UIColor(red: 95.0/255, green: 106.0/255, blue: 122.0/255, alpha: 1.0)
        }
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    @IBAction func fahrenheitfieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeperator = string.range(of: ".")
        let lateNegativeSign = !(textField.text?.isEmpty)! && (string.range(of: "-") != nil)
        print(lateNegativeSign)
        
        for char in string.characters {
            if !digits.contains(String(char)) {
                return false
            }
        }
        
        if ((existingTextHasDecimalSeperator != nil) &&
            (replacementTextHasDecimalSeperator != nil)) ||
            (lateNegativeSign == true) {
            return false
        } else {
            return true
        }
    }
}
