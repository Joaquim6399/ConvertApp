//
//  TemperatureViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 17/03/2021.
//

import UIKit

class TemperatureViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFields: [UITextField]!
    
    var roundingTo = Rounding.roundingNumber
    
    var temperatureArray = [Measurement<UnitTemperature>]()
    var activeTextField = UITextField()
    var savedTempConversions = [TemperatureModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        for i in 0...2
        {
            self.textFields[i].text = ""
        }
        
        
        //Retrive conversion history list
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let tempOut = defaults.object(forKey: "temperatureConversions") as? Data
        {
            if let temperature = try? decoder.decode([TemperatureModel].self, from: tempOut)
            {
                print("temp obj: \(temperature)")
                savedTempConversions = temperature
            }
        }
        
        if !savedTempConversions.isEmpty
        {
            //Small test on conversions
            print("saved: \(savedTempConversions.count)")
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
    
    func saveTemperatureConversions()
    {
        
        if(isTextFieldsValid())
        {
            
            //Create instance of TemperatureModel with values from textfields
            let temperature = TemperatureModel(celsiusValue: temperatureArray[0].value, fahrValue: temperatureArray[1].value, kelvinValue: temperatureArray[2].value)
            
            print("Count is here now\(savedTempConversions.count)")
            //Queue implementation
            if savedTempConversions.count >= 5
            {
                for i in 0...3
                {
                    savedTempConversions[i] = savedTempConversions[i+1]
                }
                
                savedTempConversions.remove(at: 4)
                print("Count is now: \(savedTempConversions.count)")
            }
            
            savedTempConversions.append(temperature)
            
            
            //Encode Array
            let defaults = UserDefaults.standard
            
            let encoder = JSONEncoder()
            
            if let encodedConversion = try? encoder.encode(savedTempConversions)
            {
                defaults.set(encodedConversion, forKey: "temperatureConversions")
                print("encode worked")
            }
        }
        
       
        
    }
    
    @IBAction func savePressed(_ sender: UIButton)
    {
        print("save button pressed")
        saveTemperatureConversions()
        
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
 
    
    func convertTemperature(temperature: Double, unitTemperature: UnitTemperature) -> [Measurement<UnitTemperature>]
    {
        let temperatureObj = Measurement(value: temperature, unit: unitTemperature)
        
        let temperatureArray = Conversion.temperatureConversion(temperature: temperatureObj)
        
        return temperatureArray
    }
    
    @IBAction func numericPressed(_ sender: UIButton)
    {
        //Button Number(eg. 0,1...9)
        let buttonSymbol = sender.currentTitle!
        
        //Check if are there any active buttons
        if self.activeTextField.text != nil
        {
            
            //Assign a unitMass to the select textField
            var unitTemperature: UnitTemperature?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Celsius.")
                    unitTemperature = UnitTemperature.celsius
                    tag = 0
                    
                case 101:
                    print("Fahrenheit.")
                    unitTemperature = UnitTemperature.fahrenheit
                    tag = 1
                    
                case 102:
                    print("Kelvin.")
                    unitTemperature = UnitTemperature.kelvin
                    tag = 2
                    
                default:
                    print("No field selected.")
                    
            }
            
            if unitTemperature != nil
            {
                
                //Add value to text field
                self.activeTextField.text! += String(buttonSymbol)
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    //Value in text Field to a Double
                    let temperatureValue = Double(activeTextField.text!)
                    
                    //Finally can use the convertWeight func with all the necesseracy parameters
                    temperatureArray = convertTemperature(temperature: temperatureValue!, unitTemperature: unitTemperature!)
                    
                    
                    //Populate text fields apart from the active one
                    for i in 0...(textFields.count - 1)
                    {
                         if(tag == i)
                         {
                            continue
                         }
                        self.textFields[i].text = String(format: "%.\(roundingTo)f \(temperatureArray[i].unit.symbol)", temperatureArray[i].value)

                    }
                } else
                {
                    //clear All textFields
                    for i in 0...2
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
              var unitTemperature: UnitTemperature?
             
              
              switch activeTextField.tag
              {
                  case 100:
                      print("Celsius.")
                      unitTemperature = UnitTemperature.celsius
                  
                      
                  case 101:
                      print("Fahrenheit.")
                      unitTemperature = UnitTemperature.fahrenheit
                    
                      
                  case 102:
                      print("Kelvin.")
                      unitTemperature = UnitTemperature.kelvin
                 
                      
                  default:
                      print("No field selected.")
                      
              }
                  
                  
                  
                  if unitTemperature != nil
                  {
                      if activeTextField.text! != ""
                      {
                          if !activeTextField.text!.contains(".")
                          {
                            if activeTextField.text! != "-"
                            {
                                self.activeTextField.text! += "."
                            }
                              
                          }
                          
                      }
                      
                  }
            
            

            
        }
    }
    
    
    
    @IBAction func minusPressed(_ sender: UIButton)
    {
        if self.activeTextField.text != nil
          {
              var unitTemperature: UnitTemperature?
             
              
              switch activeTextField.tag
              {
                  case 100:
                      print("Celsius.")
                      unitTemperature = UnitTemperature.celsius
                  
                      
                  case 101:
                      print("Fahrenheit.")
                      unitTemperature = UnitTemperature.fahrenheit
                    
                      
                  case 102:
                      print("Kelvin.")
                      unitTemperature = UnitTemperature.kelvin
                 
                      
                  default:
                      print("No field selected.")
                      
              }
                  
                  
                  
                  if unitTemperature != nil
                  {
                      if activeTextField.text! == ""
                      {
                          if !activeTextField.text!.contains("-")
                          {
                              self.activeTextField.text! += "-"
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
            var unitTemperature: UnitTemperature?
            var tag = -1
            
            switch activeTextField.tag
            {
                case 100:
                    print("Celsius.")
                    unitTemperature = UnitTemperature.celsius
                    tag = 0
                    
                case 101:
                    print("Fahrenheit.")
                    unitTemperature = UnitTemperature.fahrenheit
                    tag = 1
                    
                case 102:
                    print("Kelvin.")
                    unitTemperature = UnitTemperature.kelvin
                    tag = 2
                    
                default:
                    print("No field selected.")
                    
            }
            

            
            if unitTemperature != nil
            {
                if activeTextField.text! != ""
                {
                    self.activeTextField.text!.removeLast()
                }
                
                //check if there is something here
                if activeTextField.text! != ""
                {
                    if activeTextField.text != "-"
                    {
                        //Value in text Field to a Double
                        let temperatureValue = Double(activeTextField.text!)
                        
                        //Finally can use the convertWeight func with all the necesseracy parameters
                        temperatureArray = convertTemperature(temperature: temperatureValue!, unitTemperature: unitTemperature!)
                        
                        
                        //Populate text fields apart from the active one
                        for i in 0...2
                        {
                             if(tag == i)
                             {
                                continue
                             }
                            self.textFields[i].text = String(format: "%.\(roundingTo)f \(temperatureArray[i].unit.symbol)", temperatureArray[i].value)

                        }
                    } else
                    {
                        //clear All textFields
                        for i in 0...2
                        {
                            self.textFields[i].text = ""
                        }
                    }
                    
                } else
                {
                    //clear All textFields
                    for i in 0...2
                    {
                        self.textFields[i].text = ""
                    }
                }
                

            }
            
            

            
        }
        
    }
    
    
}

