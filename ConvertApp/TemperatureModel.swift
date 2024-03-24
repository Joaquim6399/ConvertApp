//
//  TemperatureModel.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 18/03/2021.
//

import Foundation

class TemperatureModel : Codable
{
    var celsius : Measurement<UnitTemperature>?
    var fahrenheit: Measurement<UnitTemperature>?
    var kelvin: Measurement<UnitTemperature>?

    init(celsiusValue: Double, fahrValue: Double, kelvinValue: Double)
    {
        celsius = Measurement(value: celsiusValue, unit: UnitTemperature.celsius)
        fahrenheit = Measurement(value: fahrValue, unit: UnitTemperature.fahrenheit)
        kelvin = Measurement(value: kelvinValue, unit: UnitTemperature.kelvin)
    }
}
