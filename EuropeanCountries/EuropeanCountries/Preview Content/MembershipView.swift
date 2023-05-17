//
//  MembershipView.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import SwiftUI

struct MembershipView: View {
    
    var country: Country
    
    var body: some View {
        
        HStack (spacing: 20) {
            
            
            if country.isEuroZone {
                Image(systemName: "eurosign.square.fill").foregroundColor(.blue).frame(width: 21, height: 14)
                
            }
            else{
                Image(systemName: "eurosign.square.fill").foregroundColor(.gray)
                    .frame(width: 21, height: 14)
                
            }
            
            
            if country.isSchengen {
                Image(systemName: "star.fill")
                    .frame(width: 21, height: 14)
                    .foregroundColor(.yellow)
                
            }
            else{
                Image(systemName: "star.fill")
                    .frame(width: 21, height: 14)
                    .foregroundColor(.gray)
                
            }
            
        }.padding()
    }
}
