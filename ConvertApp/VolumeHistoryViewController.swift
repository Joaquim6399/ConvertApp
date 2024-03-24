//
//  VolumeHistoryViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 19/03/2021.
//

import UIKit

class VolumeHistoryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var savedVolumeConversions = [VolumeModel]()
    
    var roundingTo = Rounding.roundingNumber

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        var formatedString = ""
        
        for volume in savedVolumeConversions
        {
            formatedString += String(format: " %.\(roundingTo)f Gallons = %.\(roundingTo)f Litres = %.\(roundingTo)f Pints = %.\(roundingTo)f  Fluid Ounce = %.\(roundingTo)f Millilitres \n \n", volume.gallons.value, volume.litres.value, volume.pints.value, volume.fluidOunces.value, volume.millilitres.value)
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
