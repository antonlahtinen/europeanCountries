//
//  CountryView.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import SwiftUI
import MapKit

struct CountryView: View {
    
    @State var country: Country
    
    @Environment(\.openURL) var openURL
    
    @State var coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var body: some View {
        
        VStack {
            
            Text("\(country.name)")
                .font(.largeTitle)
            
            
            Image(country.code.lowercased())
                .resizable()
                .scaledToFit()
                .border(Color.black, width: 1)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
            
        
            CountryDetailsView(country: country).fixedSize(horizontal: false, vertical: true)
      
           
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 7.0, longitudeDelta: 5.0))))
                .cornerRadius(10)
                
                            .onAppear {
                                let geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(country.name) { placemarks, error in
                                    if let placemark = placemarks?.first,
                                       let location = placemark.location {
                                        coordinates = location.coordinate
                                    }
                                }
                            }
            
            
            Button("Learn more from Wikipedia"){
                if country.name == "United Kingdom"{
                    openURL(URL(string: "https://en.wikipedia.org/wiki/Great_Britain")!)
                    
                }
                else if country.name == "Czech Republic"{
                    
                    openURL(URL(string: "https://en.wikipedia.org/wiki/Czech_Republic")!)
                }
                else{
                    openURL(URL(string: "https://en.wikipedia.org/wiki/\(country.name)")!)
                }
            }.buttonStyle(BlueButton())
                .frame(maxHeight: .some(70), alignment: .bottom)
            
        }.padding()
        
        
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(country: finland)
    }
}


struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        
    }
}
