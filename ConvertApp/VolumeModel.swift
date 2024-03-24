//
//  VolumeModel.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 18/03/2021.
//

import Foundation


class VolumeModel : Codable
{
    var gallons: Measurement<UnitVolume>
    var litres: Measurement<UnitVolume>
    var pints: Measurement<UnitVolume>
    var fluidOunces: Measurement<UnitVolume>
    var millilitres: Measurement<UnitVolume>
    
    init(gallonsValue: Double, litresValue: Double, pintsValue: Double,fluidOuncesValue: Double,millilitresValue: Double)
    {
        gallons = Measurement(value: gallonsValue, unit: UnitVolume.imperialGallons)
        litres = Measurement(value: litresValue, unit: UnitVolume.liters)
        pints = Measurement(value: pintsValue, unit: UnitVolume.imperialPints)
        fluidOunces = Measurement(value: fluidOuncesValue, unit: UnitVolume.fluidOunces)
        millilitres = Measurement(value: millilitresValue, unit: UnitVolume.milliliters)
    }
}
