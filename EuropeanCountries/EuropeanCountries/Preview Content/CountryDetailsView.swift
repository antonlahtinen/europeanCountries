//
//  CountryDetailsView.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import SwiftUI

struct CountryDetailsView: View {
    
    @State var country: Country
    
    var body: some View {
        VStack {
            
                MembershipView(country: country)
                    .font(.system(size: 30))
            
            HStack(spacing: 25){
                Text("Area:\n\(country.area) km\u{B2}")
                Text("Population:\n\(country.population)")
                Text("Density:\n\(country.populationDensity)/km\u{B2}")
            }.padding()
            .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color.white))
            .clipped()
            .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
                
        }.padding()
    }
}

struct CountryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailsView(country: finland)
    }
}

