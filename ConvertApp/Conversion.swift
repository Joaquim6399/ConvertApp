//
//  Conversion.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 18/03/2021.
//

import Foundation


class Conversion
{

    static func weightConversion(weight: Measurement<UnitMass>) -> [Measurement<UnitMass>]
    {
        let weightInKg = weight.converted(to: UnitMass.kilograms)
        let weightInGrams = weight.converted(to: UnitMass.grams)
        let weightInOunces = weight.converted(to: UnitMass.ounces)
        let weightInPounds = weight.converted(to: UnitMass.pounds)
        let weightInStones = weight.converted(to: UnitMass.stones)
        
        let arrayOfWeights = [weightInKg, weightInGrams, weightInOunces, weightInPounds, weightInStones]
        
        return arrayOfWeights
    }
    
    static func temperatureConversion(temperature: Measurement<UnitTemperature>) -> [Measurement<UnitTemperature>]
    {
        let tempInCelsius = temperature.converted(to: UnitTemperature.celsius)
        let tempInFahr = temperature.converted(to: UnitTemperature.fahrenheit)
        let tempInKelvin = temperature.converted(to: UnitTemperature.kelvin)
        
        let arrayOfTemperatures = [tempInCelsius, tempInFahr, tempInKelvin]
        
        return arrayOfTemperatures
    }
    
    static func lengthConversion(length: Measurement<UnitLength>) -> [Measurement<UnitLength>]
    {
        let lengthInMeters = length.converted(to: UnitLength.meters)
        let lengthInKilometers = length.converted(to: UnitLength.kilometers)
        let lengthInMiles = length.converted(to: UnitLength.miles)
        let lengthInCm = length.converted(to: UnitLength.centimeters)
        let lengthInMm = length.converted(to: UnitLength.millimeters)
        let lengthInYards = length.converted(to: UnitLength.yards)
        let lengthInInches = length.converted(to: UnitLength.inches)
        
        let arrayOfLengths = [lengthInMeters, lengthInKilometers, lengthInMiles, lengthInCm, lengthInMm, lengthInYards, lengthInInches]
    
        return arrayOfLengths
    }
    
    static func speedConversion(speed: Measurement<UnitSpeed>) -> [Measurement<UnitSpeed>]
    {
        let speedInMps = speed.converted(to: UnitSpeed.metersPerSecond)
        let speedInKph = speed.converted(to: UnitSpeed.kilometersPerHour)
        let speedInMpH = speed.converted(to: UnitSpeed.milesPerHour)
        let speedInknots = speed.converted(to: UnitSpeed.knots)
        
        let arrayOfSpeeds = [speedInMps, speedInKph, speedInMpH, speedInknots]
        
        return arrayOfSpeeds
    }
    
    static func volumeConversion(volume: Measurement<UnitVolume>) -> [Measurement<UnitVolume>]
    {
        let volumeInGallons = volume.converted(to: UnitVolume.imperialGallons)
        let volumeInlitres = volume.converted(to: UnitVolume.liters)
        let volumeInPints = volume.converted(to: UnitVolume.imperialPints)
        let volumeInOunces = volume.converted(to: UnitVolume.fluidOunces)
        let volumeInMillilitres = volume.converted(to: UnitVolume.milliliters)
        
        let arrayOfVolumes = [volumeInGallons, volumeInlitres, volumeInPints, volumeInOunces, volumeInMillilitres]
        
        return arrayOfVolumes
    }
}
