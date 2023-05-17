//
//  Country.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import Foundation

struct Country: Identifiable, Codable {
    
    let id = UUID()
    var code: String
    var name: String
    var area: Int
    var population: Int
    var populationDensity: Int {
        return self.population / self.area
    }
    var isMember: Bool
    var isSchengen: Bool
    var isEuroZone: Bool
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case area
        case population
        case isMember
        case isSchengen
        case isEuroZone
    }
}
