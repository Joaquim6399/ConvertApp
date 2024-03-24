//
//  WeightModel.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 18/03/2021.
//

import Foundation


class WeightModel : Codable
{
    var kilograms : Measurement<UnitMass>?
    var grams: Measurement<UnitMass>?
    var ounces: Measurement<UnitMass>?
    var pounds: Measurement<UnitMass>?
    var stones: Measurement<UnitMass>?

    init(kiloValue: Double, gramsValue: Double, ouncesValue: Double, poundsValue: Double, stonesValue: Double)
    {
        kilograms = Measurement(value: kiloValue, unit: UnitMass.kilograms)
        grams = Measurement(value: gramsValue, unit: UnitMass.grams)
        ounces = Measurement(value: ouncesValue, unit: UnitMass.ounces)
        pounds = Measurement(value: poundsValue, unit: UnitMass.pounds)
        stones = Measurement(value: stonesValue, unit: UnitMass.stones)
    }
}






