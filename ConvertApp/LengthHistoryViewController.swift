//
//  LengthHistoryViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 19/03/2021.
//

import UIKit

class LengthHistoryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var savedLengthConversions = [LengthModel]()
    
    var roundingTo = Rounding.roundingNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Retrive conversion history list
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let lengthOut = defaults.object(forKey: "lengthConversions") as? Data
        {
            if let length = try? decoder.decode([LengthModel].self, from: lengthOut)
            {
                print("length obj: \(length)")
                savedLengthConversions = length
            }
        }
        
        if !savedLengthConversions.isEmpty
        {
            //Small test on conversions
            print("saved: \(savedLengthConversions.count)")
        }
        
        var formatedString = ""
        
        for length in savedLengthConversions
        {
            formatedString += String(format: " %.\(roundingTo)f Metres = %.\(roundingTo)f Kilometers = %.\(roundingTo)f Miles = %.\(roundingTo)f  Centimeters = %.\(roundingTo)f Millimeters %.\(roundingTo)f Yards = %.\(roundingTo)f Inches \n \n", length.meters.value, length.kilometers.value, length.miles.value, length.centimeters.value, length.millimeters.value, length.yards.value, length.inches.value)
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
