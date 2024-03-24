//
//  VolumeViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 17/03/2021.
//

import UIKit

class VolumeViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textFields: [UITextField]!
    
    var roundingTo = Rounding.roundingNumber
    
    var volumeArray = [Measurement<UnitVolume>]()
    var activeTextField = UITextField()
    var savedVolumeConversions = [VolumeModel]()
    
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

        if let volumeOut = defaults.object(forKey: "volumeConversions") as? Data
        {
            if let volume = try? decoder.decode([VolumeModel].self, from: volumeOut)
            {
                print("volume obj: \(volume)")
                savedVolumeConversions = volume
            }
        }
        
        if !savedVolumeConversions.isEmpty
        {
            //Small test on conversions
              
            print("saved: \(savedVolumeConversions.count)")
            
             
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
    
    func saveVolumeConversions()
    {
        
        if(isTextFieldsValid())
        {
            
            //Create instance of LengthModel with values from textfields
            let volume = VolumeModel(gallonsValue: volumeArray[0].value, litresValue: volumeArray[1].value, pintsValue: volumeArray[2].value, fluidOuncesValue: volumeArray[3].value, millilitresValue: volumeArray[4].value)
            
            //Queue implementation
            if savedVolumeConversions.count >= 5
            {
                for i in 0...3
                {
                    savedVolumeConversions[i] = savedVolumeConversions[i+1]
                }
                
                savedVolumeConversions.remove(at: 4)
                print("Count is now: \(savedVolumeConversions.count)")
            }
            
            savedVolumeConversions.append(volume)
            
            
            
            //Encode Array
            let defaults = UserDefaults.standard
            
            let encoder = JSONEncoder()
            
            if let encodedConversion = try? encoder.encode(savedVolumeConversions)
            {
                
                defaults.set(encodedConversion, forKey: "volumeConversions")
                print("encode worked")
            }
        }
        
       
        
    }

    @IBAction func savePressed(_ sender: UIButton)
    {
        print("save button pressed")
        saveVolumeConversions()
        
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
 
    
    func convertVolume(volume: Double, unitVolume: UnitVolume) -> [Measurement<UnitVolume>]
    {
        let volumeObj = Measurement(value: volume, unit: unitVolume)
        
        let volumeArray = Conversion.volumeConversion(volume: volumeObj)
        
        return volumeArray
    }
    
    @IBAction func numericPressed(_ sender: UIButton)
    {
        //Button Number(eg. 0,1...9)
        let buttonSymbol = sender.currentTitle!
        
        //Check if are there any active buttons
        if self.activeTextField.text != nil
        {
            
            //Assign a unitMass to the select textField
            var unitVolume: UnitVolume?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Gallons.")
                    unitVolume = UnitVolume.imperialGallons
                    tag = 0
                    
                case 101:
                    print("Litres.")
                    unitVolume = UnitVolume.liters
                    tag = 1
                    
                case 102:
                    print("Pint.")
                    unitVolume = UnitVolume.imperialPints
                    tag = 2
                    
                case 103:
                    print("Fluid Ounces.")
                    unitVolume = UnitVolume.fluidOunces
                    tag = 3
                
                case 104:
                    print("Millilitre.")
                    unitVolume = UnitVolume.milliliters
                    tag = 4
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitVolume != nil
            {
                
                //Add value to text field
                self.activeTextField.text! += String(buttonSymbol)
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let volumeValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    volumeArray = convertVolume(volume: volumeValue!, unitVolume: unitVolume!)
                    
                    
                    //Populate text fields apart from the active one
                    for i in 0...(textFields.count - 1)
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(volumeArray[i].unit.symbol)", volumeArray[i].value)

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
            var unitVolume: UnitVolume?
            
            switch activeTextField.tag
            {
                case 100:
                    print("Gallons.")
                    unitVolume = UnitVolume.imperialGallons
                    
                case 101:
                    print("Litres.")
                    unitVolume = UnitVolume.liters
                    
                case 102:
                    print("Pint.")
                    unitVolume = UnitVolume.imperialPints
                    
                case 103:
                    print("Fluid Ounces.")
                    unitVolume = UnitVolume.fluidOunces
                
                case 104:
                    print("Millilitre.")
                    unitVolume = UnitVolume.milliliters
                    
                default:
                    print("No field selected.")
                    
            }
            
            
            if unitVolume != nil
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
            var unitVolume: UnitVolume?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Gallons.")
                    unitVolume = UnitVolume.imperialGallons
                    tag = 0
                    
                case 101:
                    print("Litres.")
                    unitVolume = UnitVolume.liters
                    tag = 1
                    
                case 102:
                    print("Pint.")
                    unitVolume = UnitVolume.imperialPints
                    tag = 2
                    
                case 103:
                    print("Fluid Ounces.")
                    unitVolume = UnitVolume.fluidOunces
                    tag = 3
                
                case 104:
                    print("Millilitre.")
                    unitVolume = UnitVolume.milliliters
                    tag = 4
                    
                default:
                    print("No field selected.")
                    
            }
            
            

            
            if unitVolume != nil
            {
                if activeTextField.text! != ""
                {
                    self.activeTextField.text!.removeLast()
                }
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let volumeValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    volumeArray = convertVolume(volume: volumeValue!, unitVolume: unitVolume!)
                    
                    //Populate text fields apart from the active one
                    for i in 0...4
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(volumeArray[i].unit.symbol)", volumeArray[i].value)

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
