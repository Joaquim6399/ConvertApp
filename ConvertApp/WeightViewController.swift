//
//  WeightViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 17/03/2021.
//

import UIKit

class WeightViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var stoneText: UITextField!
    @IBOutlet weak var poundText: UITextField!
    
    var roundingTo = Rounding.roundingNumber
    
    var weightArray = [Measurement<UnitMass>]()
    var activeTextField = UITextField()
    var savedWeightConversions = [WeightModel]()
    
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
        for i in 0...4
        {
            self.textFields[i].text = ""
        }
        
        
        //Retrive conversion history list
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let weightOut = defaults.object(forKey: "weightConversions") as? Data
        {
            if let weight = try? decoder.decode([WeightModel].self, from: weightOut)
            {
                print("weight obj: \(weight)")
                savedWeightConversions = weight
            }
        }
        
        if !savedWeightConversions.isEmpty
        {
            //Small test on conversions
            
             
             
            print("saved: \(savedWeightConversions.count)")
            
            for i in 0...(savedWeightConversions.count - 1)
            {
                print(savedWeightConversions[i].kilograms!.value)
            }
             
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
    
    func saveWeightConversions()
    {
        
        if(isTextFieldsValid())
        {
            
            //Create instance of Weight with values from textfields
            let weight = WeightModel(kiloValue: weightArray[0].value, gramsValue: weightArray[1].value, ouncesValue: weightArray[2].value, poundsValue: weightArray[3].value, stonesValue: weightArray[4].value)
            
            //Queue implementation
            if savedWeightConversions.count >= 5
            {
                for i in 0...3
                {
                    savedWeightConversions[i] = savedWeightConversions[i+1]
                }
                
                savedWeightConversions.remove(at: 4)
                print("Count is now: \(savedWeightConversions.count)")
            }
            
            savedWeightConversions.append(weight)
            
            
            //Encode Array
            let defaults = UserDefaults.standard
            
            let encoder = JSONEncoder()
            
            if let encodedConversion = try? encoder.encode(savedWeightConversions)
            {
                defaults.set(encodedConversion, forKey: "weightConversions")
                
            }
        }
        
       
        
    }
    
    
    
    @IBAction func savePressed(_ sender: UIButton)
    {
        print("save button pressed")
        saveWeightConversions()
        
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
 
    
    func convertWeight(weight: Double, unitMass: UnitMass) -> [Measurement<UnitMass>]
    {
        let weightObj = Measurement(value: weight, unit: unitMass)
        
        let weightArray = Conversion.weightConversion(weight: weightObj)
        
        return weightArray
    }
    
    @IBAction func numericPressed(_ sender: UIButton)
    {
        //Button Number(eg. 0,1...9)
        let buttonSymbol = sender.currentTitle!
        
        //Check if are there any active buttons
        if self.activeTextField.text != nil
        {
            
            //Assign a unitMass to the select textField
            var unitMass: UnitMass?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Kilo.")
                    unitMass = UnitMass.kilograms
                    tag = 0
                    
                case 101:
                    print("Grams.")
                    unitMass = UnitMass.grams
                    tag = 1
                    
                case 102:
                    print("Ounces.")
                    unitMass = UnitMass.ounces
                    tag = 2
                    
                case 103:
                    print("Pounds.")
                    unitMass = UnitMass.pounds
                    tag = 3
                
                case 104:
                    print("Stone.")
                    unitMass = UnitMass.stones
                    tag = 4
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitMass != nil
            {
                
                //Add value to text field
                self.activeTextField.text! += String(buttonSymbol)
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let weightValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    weightArray = convertWeight(weight: weightValue!, unitMass: unitMass!)
                    
                    
                    //Populate text fields apart from the active one
                    for i in 0...(textFields.count - 1)
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(weightArray[i].unit.symbol)", weightArray[i].value)
                        
                        
                    
                        
                    }
                } else
                {
                    //clear All textFields
                    for i in 0...4
                    {
                        self.textFields[i].text = ""
                    }
                }
                
                let stone_pound:Double = weightArray[4].value
                
                let stone  = trunc(stone_pound)
                
                let pound = stone_pound.truncatingRemainder(dividingBy: 1)
                
                stoneText.text = String(format: "%.\(roundingTo)f", stone)
                
                poundText.text = String(format: "%.\(roundingTo)f", pound)

            }
            
            
        }
        
        
    }

    @IBAction func dotPressed(_ sender: UIButton)
    {
        if self.activeTextField.text != nil
        {
            var unitMass: UnitMass?

            
            switch activeTextField.tag
            {
                case 100:
                    print("Kilo.")
                    unitMass = UnitMass.kilograms
                  
                    
                case 101:
                    print("Grams.")
                    unitMass = UnitMass.grams
                   
                    
                case 102:
                    print("Ounces.")
                    unitMass = UnitMass.ounces
                    
                    
                case 103:
                    print("Pounds.")
                    unitMass = UnitMass.pounds
                  
                
                case 104:
                    print("Stone.")
                    unitMass = UnitMass.stones
                  
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitMass != nil
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
            var unitMass: UnitMass?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Kilo.")
                    unitMass = UnitMass.kilograms
                    tag = 0
                    
                case 101:
                    print("Grams.")
                    unitMass = UnitMass.grams
                    tag = 1
                    
                case 102:
                    print("Ounces.")
                    unitMass = UnitMass.ounces
                    tag = 2
                    
                case 103:
                    print("Pounds.")
                    unitMass = UnitMass.pounds
                    tag = 3
                
                case 104:
                    print("Stone.")
                    unitMass = UnitMass.stones
                    tag = 4
                    
                default:
                    print("No field selected.")
                    
            }
            

            
            if unitMass != nil
            {
                if activeTextField.text! != ""
                {
                    self.activeTextField.text!.removeLast()
                }
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let weightValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    weightArray = convertWeight(weight: weightValue!, unitMass: unitMass!)
                    
                    
                    //Populate text fields apart from the active one
                    for i in 0...4
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(weightArray[i].unit.symbol)", weightArray[i].value)

                    }
                } else
                {
                    //clear All textFields
                    for i in 0...4
                    {
                        self.textFields[i].text = ""
                    }
                    
                    stoneText.text = ""
                    
                    poundText.text = ""
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
