//
//  LengthModel.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 18/03/2021.
//

import Foundation


class LengthModel : Codable
{
    var meters: Measurement<UnitLength>
    var kilometers: Measurement<UnitLength>
    var miles: Measurement<UnitLength>
    var centimeters: Measurement<UnitLength>
    var millimeters: Measurement<UnitLength>
    var yards: Measurement<UnitLength>
    var inches: Measurement<UnitLength>
    
    init(metersValue: Double, kilometersValue: Double, milesValue: Double, centimetersValue: Double, millimetersValue: Double, yardsValue: Double, inchesValue: Double)
    {
        meters = Measurement(value: metersValue, unit: UnitLength.meters)
        kilometers = Measurement(value: kilometersValue, unit: UnitLength.kilometers)
        miles = Measurement(value: milesValue, unit: UnitLength.miles)
        centimeters = Measurement(value: centimetersValue, unit: UnitLength.centimeters)
        millimeters = Measurement(value: millimetersValue, unit: UnitLength.millimeters)
        yards = Measurement(value: yardsValue, unit: UnitLength.yards)
        inches = Measurement(value: inchesValue, unit: UnitLength.inches)
    }
}
