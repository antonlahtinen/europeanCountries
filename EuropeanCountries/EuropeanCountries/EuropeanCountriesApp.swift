//
//  EuropeanCountriesApp.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import SwiftUI


let finland = Country(code: "FI", name: "Finland", area: 338_435, population: 5_555_300, isMember: true, isSchengen: true, isEuroZone: true)


@main
struct EuropeanCountries: App {
    
    @StateObject private var manager = CountryManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)
        }
    }
}
