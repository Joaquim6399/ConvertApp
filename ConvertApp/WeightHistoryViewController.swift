//
//  WeightHistoryViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 19/03/2021.
//

import UIKit

class WeightHistoryViewController: UIViewController {


    var savedWeightConversions = [WeightModel]()
    
    @IBOutlet weak var textView: UITextView!
    
    
    var roundingTo = Rounding.roundingNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        
        var formatedString = ""
        
        for weight in savedWeightConversions
        {
            formatedString += String(format: " %.\(roundingTo)f Kg = %.\(roundingTo)f Grams = %.\(roundingTo)f Ounces = %.\(roundingTo)f Pounds = %.\(roundingTo)f Stone-pounds \n \n", weight.kilograms!.value, weight.grams!.value, weight.ounces!.value, weight.pounds!.value, weight.stones!.value)
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
