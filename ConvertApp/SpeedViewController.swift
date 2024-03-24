//
//  SpeedViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 17/03/2021.
//

import UIKit

class SpeedViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textFields: [UITextField]!
    
    var roundingTo = Rounding.roundingNumber
    
    var speedArray = [Measurement<UnitSpeed>]()
    var activeTextField = UITextField()
    var savedSpeedConversions = [SpeedModel]()
    
    
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
        for i in 0...3
        {
            self.textFields[i].text = ""
        }
        
        //Retrive conversion history list
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let speedOut = defaults.object(forKey: "speedConversions") as? Data
        {
            if let speed = try? decoder.decode([SpeedModel].self, from: speedOut)
            {
                print("weight obj: \(speed)")
                savedSpeedConversions = speed
            }
        }
        
        if !savedSpeedConversions.isEmpty
        {
            //Small test on conversions
            print("saved: \(savedSpeedConversions.count)")
            
             
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
    
    func saveSpeedConversions()
    {
        
        if(isTextFieldsValid())
        {
            
            //Create instance of LengthModel with values from textfields
            
            
            let speed = SpeedModel(mphValue: speedArray[0].value, kphValue: speedArray[1].value, milesphValue: speedArray[2].value, knotsValue: speedArray[3].value)
            
            
            //Queue implementation
            if savedSpeedConversions.count >= 5
            {
                for i in 0...3
                {
                    savedSpeedConversions[i] = savedSpeedConversions[i+1]
                }
                
                savedSpeedConversions.remove(at: 4)
                print("Count is now: \(savedSpeedConversions.count)")
            }
            
            savedSpeedConversions.append(speed)
            
            
            
            //Encode Array
            let defaults = UserDefaults.standard
            
            let encoder = JSONEncoder()
            
            if let encodedConversion = try? encoder.encode(savedSpeedConversions)
            {
                defaults.set(encodedConversion, forKey: "speedConversions")
                
            }
        }
        
       
        
    }

    
    @IBAction func savePressed(_ sender: UIButton)
    {
        print("save button pressed")
        saveSpeedConversions()
        
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
 
    
    func convertSpeed(speed: Double, unitSpeed: UnitSpeed) -> [Measurement<UnitSpeed>]
    {
        let speedObj = Measurement(value: speed, unit: unitSpeed)
        
        let speedArray = Conversion.speedConversion(speed: speedObj)
        
        return speedArray
    }
    
    @IBAction func numericPressed(_ sender: UIButton)
    {
        //Button Number(eg. 0,1...9)
        let buttonSymbol = sender.currentTitle!
        
        //Check if are there any active buttons
        if self.activeTextField.text != nil
        {
            
            //Assign a unitMass to the select textField
            var unitSpeed: UnitSpeed?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Mps.")
                    unitSpeed = UnitSpeed.metersPerSecond
                    tag = 0
                    
                case 101:
                    print("Kph.")
                    unitSpeed = UnitSpeed.kilometersPerHour
                    tag = 1
                    
                case 102:
                    print("Mph.")
                    unitSpeed = UnitSpeed.milesPerHour
                    tag = 2
                    
                case 103:
                    print("Knot.")
                    unitSpeed = UnitSpeed.knots
                    tag = 3
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitSpeed != nil
            {
                
                //Add value to text field
                self.activeTextField.text! += String(buttonSymbol)
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let speedValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    speedArray = convertSpeed(speed: speedValue!, unitSpeed: unitSpeed!)
                    
                    
                    //Populate text fields apart from the active one
                    for i in 0...(textFields.count - 1)
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(speedArray[i].unit.symbol)", speedArray[i].value)

                    }
                } else
                {
                    //clear All textFields
                    for i in 0...4
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
            var unitSpeed: UnitSpeed?
            
            switch activeTextField.tag
            {
                case 100:
                    print("Mps.")
                    unitSpeed = UnitSpeed.metersPerSecond
                    
                case 101:
                    print("Kph.")
                    unitSpeed = UnitSpeed.kilometersPerHour
                    
                case 102:
                    print("Mph.")
                    unitSpeed = UnitSpeed.milesPerHour
                    
                case 103:
                    print("Knot.")
                    unitSpeed = UnitSpeed.knots
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitSpeed != nil
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
            var unitSpeed: UnitSpeed?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Mps.")
                    unitSpeed = UnitSpeed.metersPerSecond
                    tag = 0
                    
                case 101:
                    print("Kph.")
                    unitSpeed = UnitSpeed.kilometersPerHour
                    tag = 1
                    
                case 102:
                    print("Mph.")
                    unitSpeed = UnitSpeed.milesPerHour
                    tag = 2
                    
                case 103:
                    print("Knot.")
                    unitSpeed = UnitSpeed.knots
                    tag = 3
                    
                default:
                    print("No field selected.")
                    
            }
            

            
            if unitSpeed != nil
            {
                if activeTextField.text! != ""
                {
                    self.activeTextField.text!.removeLast()
                }
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let speedValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    speedArray = convertSpeed(speed: speedValue!, unitSpeed: unitSpeed!)
                    
                    //Populate text fields apart from the active one
                    for i in 0...(textFields.count - 1)
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(speedArray[i].unit.symbol)", speedArray[i].value)

                    }
                } else
                {
                    //clear All textFields
                    for i in 0...(textFields.count - 1)
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
