//
//  SettingsViewController.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 19/03/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl)
    {
        
        print("# of Segments = \(sender.numberOfSegments)")
        
        switch sender.selectedSegmentIndex
        {
            case 0:
                print(" .2 selected")
                Rounding.roundingNumber = 2
            case 1:
                print(" .3 selected")
                Rounding.roundingNumber = 3
            case 2:
                print(" .4 selected")
                Rounding.roundingNumber = 4
        
            default:
                break
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
