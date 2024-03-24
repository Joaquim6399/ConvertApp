//
//  SpeedHistoryViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 19/03/2021.
//

import UIKit

class SpeedHistoryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var savedSpeedConversions = [SpeedModel]()
    
    var roundingTo = Rounding.roundingNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Retrive conversion history list
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let speedOut = defaults.object(forKey: "speedConversions") as? Data
        {
            if let speed = try? decoder.decode([SpeedModel].self, from: speedOut)
            {
                print("speed obj: \(speed)")
                savedSpeedConversions = speed
            }
        }
        
        if !savedSpeedConversions.isEmpty
        {
            //Small test on conversions
            print("saved: \(savedSpeedConversions.count)")
        }
        
        var formatedString = ""
        
        for speed in savedSpeedConversions
        {
            formatedString += String(format: " %.\(roundingTo)f Meters/Sec = %.\(roundingTo)f Kilometers/Hour = %.\(roundingTo)f Miles/Hour = %.\(roundingTo)f  Knots \n \n", speed.meterPerSecond.value, speed.kilometersPerHour.value, speed.milesPerHour.value, speed.knots.value)
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
