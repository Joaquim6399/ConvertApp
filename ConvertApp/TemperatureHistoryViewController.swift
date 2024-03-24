//
//  TemperatureHistoryViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 19/03/2021.
//

import UIKit

class TemperatureHistoryViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var savedTempConversions = [TemperatureModel]()

    
    var roundingTo = Rounding.roundingNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
            
            for i in 0...(savedTempConversions.count - 1)
            {
                print("Celsius:\(savedTempConversions[i].celsius!.value)")
                print("Fahr:\(savedTempConversions[i].fahrenheit!.value)")
                print("Kelvin:\(savedTempConversions[i].kelvin!.value)")
            }
        }
        
        var formatedString = ""
        
        for temp in savedTempConversions
        {
            formatedString += String(format: " %.\(roundingTo)f Celsius = %.\(roundingTo)f Fahrenheit = %.\(roundingTo)f Kelvin  \n \n", temp.celsius!.value, temp.fahrenheit!.value, temp.kelvin!.value)
        }
        
       
        textView.text = formatedString
        
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
