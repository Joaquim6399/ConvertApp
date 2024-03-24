//
//  LengthViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 17/03/2021.
//

import UIKit

class LengthViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var textFields: [UITextField]!
    
    
    var roundingTo = Rounding.roundingNumber
    
    var lengthArray = [Measurement<UnitLength>]()
    var activeTextField = UITextField()
    var savedLengthConversions = [LengthModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Dont show keyboard
        for item in textFields
        {
            item.inputView = UIView()
            item.inputAccessoryView = UIView()
        }
        
        //Give Tags to each textfield start @100
        var i = 100
        for item in textFields
        {
            item.tag = i
            i += 1
        }
        
        //clear All textFields
        for i in 0...6
        {
            self.textFields[i].text = ""
        }
        
        
        //Retrive conversion history list
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let lengthOut = defaults.object(forKey: "lengthConversions") as? Data
        {
            if let length = try? decoder.decode([LengthModel].self, from: lengthOut)
            {
                print("weight obj: \(length)")
                savedLengthConversions = length
            }
        }
        
        if !savedLengthConversions.isEmpty
        {
            //Small test on conversions
              
            print("saved: \(savedLengthConversions.count)")
            
             
        }
    }
    
    func isTextFieldsValid() -> Bool
    {
            
        var isValid: Bool = false
        
        for textField in textFields
        {
            if textField.text == ""
            {
                print("text field is valid? = \(isValid)")
                return isValid
            }
        }
        
        isValid = true
        
        print("text field is valid? = \(isValid)")
        
        return isValid
        
        
    }
    
    func saveLengthConversions()
    {
        
        if(isTextFieldsValid())
        {
            
            //Create instance of LengthModel with values from textfields
            let lenght = LengthModel(metersValue: lengthArray[0].value, kilometersValue: lengthArray[1].value, milesValue: lengthArray[2].value, centimetersValue: lengthArray[3].value, millimetersValue: lengthArray[4].value, yardsValue: lengthArray[5].value, inchesValue: lengthArray[6].value)
            
            //Queue implementation
            if savedLengthConversions.count >= 5
            {
                for i in 0...3
                {
                savedLengthConversions[i] = savedLengthConversions[i+1]
                }
                
                savedLengthConversions.remove(at: 4)
                print("Count is now: \(savedLengthConversions.count)")
            }
            
            savedLengthConversions.append(lenght)
            
            
            
            //Encode Array
            let defaults = UserDefaults.standard
            
            let encoder = JSONEncoder()
            
            if let encodedConversion = try? encoder.encode(savedLengthConversions)
            {
                defaults.set(encodedConversion, forKey: "lengthConversions")
                
            }
        }
        
       
        
    }
    
    
    @IBAction func savePressed(_ sender: UIButton)
    {
        print("save button pressed")
        saveLengthConversions()
        
        for items in textFields
        {
            items.text = ""
        }
    }
    
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.activeTextField = textField
    }
 
    
    func convertLength(length: Double, unitLength: UnitLength) -> [Measurement<UnitLength>]
    {
        let lengthObj = Measurement(value: length, unit: unitLength)
        
        let lengthArray = Conversion.lengthConversion(length: lengthObj)
        
        return lengthArray
    }
    
    @IBAction func numericPressed(_ sender: UIButton)
    {
        //Button Number(eg. 0,1...9)
        let buttonSymbol = sender.currentTitle!
        
        //Check if are there any active buttons
        if self.activeTextField.text != nil
        {
            
            //Assign a unitMass to the select textField
            var unitLength: UnitLength?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Metres.")
                    unitLength = UnitLength.meters
                    tag = 0
                    
                case 101:
                    print("Kilometers.")
                    unitLength = UnitLength.kilometers
                    tag = 1
                    
                case 102:
                    print("Miles.")
                    unitLength = UnitLength.miles
                    tag = 2
                    
                case 103:
                    print("centimeters.")
                    unitLength = UnitLength.centimeters
                    tag = 3
                
                case 104:
                    print("Millimeters.")
                    unitLength = UnitLength.millimeters
                    tag = 4
                case 105:
                    print("Yards.")
                    unitLength = UnitLength.yards
                    tag = 5
                case 106:
                    print("Inches.")
                    unitLength = UnitLength.inches
                    tag = 6
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitLength != nil
            {
                
                //Add value to text field
                self.activeTextField.text! += String(buttonSymbol)
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let lengthValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    lengthArray = convertLength(length: lengthValue!, unitLength: unitLength!)
                    
                    
                    //Populate text fields apart from the active one
                    for i in 0...(textFields.count - 1)
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(lengthArray[i].unit.symbol)", lengthArray[i].value)

                    }
                } else
                {
                    //clear All textFields
                    for i in 0...6
                    {
                        self.textFields[i].text = ""
                    }
                }
                

            }
            
            
        }
        
        
    }

    @IBAction func dotPressed(_ sender: UIButton)
    {
        if self.activeTextField.text != nil
        {
            //Assign a unitMass to the select textField
            var unitLength: UnitLength?
            
            switch activeTextField.tag
            {
                case 100:
                    print("Metres.")
                    unitLength = UnitLength.meters
                    
                case 101:
                    print("Kilometers.")
                    unitLength = UnitLength.kilometers
                    
                case 102:
                    print("Miles.")
                    unitLength = UnitLength.miles
                    
                case 103:
                    print("centimeters.")
                    unitLength = UnitLength.centimeters
                
                case 104:
                    print("Millimeters.")
                    unitLength = UnitLength.millimeters
                    
                case 105:
                    print("Yards.")
                    unitLength = UnitLength.yards
                    
                case 106:
                    print("Inches.")
                    unitLength = UnitLength.inches
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitLength != nil
            {
                if activeTextField.text! != ""
                {
                    if !activeTextField.text!.contains(".")
                    {
                        self.activeTextField.text! += "."
                    }
                    
                }
                
            }
            
            

            
        }
    }
    
    
    
    @IBAction func deletePressed(_ sender: UIButton)
    {
        
        if self.activeTextField.text != nil
        {
            //Assign a unitMass to the select textField
            var unitLength: UnitLength?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Metres.")
                    unitLength = UnitLength.meters
                    tag = 0
                    
                case 101:
                    print("Kilometers.")
                    unitLength = UnitLength.kilometers
                    tag = 1
                    
                case 102:
                    print("Miles.")
                    unitLength = UnitLength.miles
                    tag = 2
                    
                case 103:
                    print("centimeters.")
                    unitLength = UnitLength.centimeters
                    tag = 3
                
                case 104:
                    print("Millimeters.")
                    unitLength = UnitLength.millimeters
                    tag = 4
                case 105:
                    print("Yards.")
                    unitLength = UnitLength.yards
                    tag = 5
                case 106:
                    print("Inches.")
                    unitLength = UnitLength.inches
                    tag = 6
                    
                default:
                    print("No field selected.")
                    
            }
            

            
            if unitLength != nil
            {
                if activeTextField.text! != ""
                {
                    self.activeTextField.text!.removeLast()
                }
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let lengthValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    lengthArray = convertLength(length: lengthValue!, unitLength: unitLength!)
                    
                    //Populate text fields apart from the active one
                    for i in 0...6
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(lengthArray[i].unit.symbol)", lengthArray[i].value)

                    }
                } else
                {
                    //clear All textFields
                    for i in 0...6
                    {
                        self.textFields[i].text = ""
                    }
                }
                

            }
            
            

            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
