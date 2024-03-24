//
//  SpeedModel.swift
//  ConvertApp
//
//  Created by Joaquim Martins Da Silva Soares on 18/03/2021.
//

import Foundation


class SpeedModel : Codable
{
    var meterPerSecond: Measurement<UnitSpeed>
    var kilometersPerHour: Measurement<UnitSpeed>
    var milesPerHour: Measurement<UnitSpeed>
    var knots: Measurement<UnitSpeed>

    init(mphValue: Double, kphValue: Double, milesphValue: Double, knotsValue: Double)
    {
        meterPerSecond = Measurement(value: mphValue, unit: UnitSpeed.metersPerSecond)
        kilometersPerHour = Measurement(value: kphValue, unit: UnitSpeed.kilometersPerHour)
        milesPerHour = Measurement(value: milesphValue, unit: UnitSpeed.milesPerHour)
        knots = Measurement(value: knotsValue, unit: UnitSpeed.knots)
    }
}
