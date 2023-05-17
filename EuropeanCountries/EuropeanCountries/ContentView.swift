//
//  ContentView.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager: CountryManager
    
    var euCountries: [Country] {
        manager.countries.filter { $0.isMember }
    }
    
    var nonEuCountries: [Country] {
        manager.countries.filter { !$0.isMember }
    }
    
    @State private var tabTitle = "European Countries"
    
    @State private var searchText = ""
    
    var filteredEuCountries: [Country] {
            euCountries.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        var filteredNonEuCountries: [Country] {
            nonEuCountries.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                if(tabTitle.self == "European Countries" || tabTitle == "Former Members"){
                    SearchBar(text: $searchText)
                    
                }
                
                
                TabView(selection: $tabTitle) {
                    
                    // First tab for EU countries
                    List {
                        Section("EU Members"){
                            ForEach(filteredEuCountries) { country in
                                NavigationLink(destination: CountryView(country: country)) {
                                    HStack {
                                        Text(country.name)
                                        Image(country.code.lowercased())
                                            .resizable()
                                            .frame(width: 18, height: 12).border(Color.black, width: 0.5)
                                        Spacer()
                                        MembershipView(country: country)
                                    }
                                }
                            }
                        }
                        
                        // First tab for EU countries
                        
                            
                            Section("Former Members") {
                                ForEach(filteredNonEuCountries) { country in
                                    NavigationLink(destination: CountryView(country: country)) {
                                        HStack {
                                            Text(country.name)
                                            Image(country.code.lowercased())
                                                .resizable()
                                                .frame(width: 18, height: 12).border(Color.black, width: 0.5)
                                            Spacer()
                                            MembershipView(country: country)
                                        }
                                    }
                                }
                        }
                        .tabItem {
                            Label("EU Members", systemImage: "star.fill")
                        }
                        .tag("European Countries")

                    }
                    .tabItem {
                        Label("EU Members", systemImage: "star.fill")
                    }
                    .tag("European Countries")
                    
                    
                
                    
                    //Second tab for info
                    VStack{
                        
                        InfoScreen()
                        
                    }.tabItem{Label("Info", systemImage: "info.circle")
                    }
                    .tag("Application Info")
                }
                .navigationTitle(Text(tabTitle))
                
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CountryManager())
    }
}





struct InfoScreen: View {
    
    
    
    var body: some View {
       
            VStack{
                
                Text("ICON INFO")
                    .font(.headline)
                    .padding()
                
                
                Text("Country is part of eurozone (€)")
                Image(systemName: "eurosign.square.fill").foregroundColor(.blue).frame(width: 21, height: 14)
                    .padding()
                
                
                Text("Country is NOT part of eurozone (€)")
                Image(systemName: "eurosign.square.fill").foregroundColor(.gray)
                    .frame(width: 21, height: 14)
                    .padding()
                
                
                Text("Country is part of Schengen agreement")
                Image(systemName: "star.fill")
                    .frame(width: 21, height: 14)
                    .foregroundColor(.yellow)
                    .padding()
    
                
                Text("Country is NOT part of Schengen agreement")
                Image(systemName: "star.fill")
                    .frame(width: 21, height: 14)
                    .foregroundColor(.gray)
                    .padding()
            
            }
        }
    }


struct SearchBar: View {
    
    
    @Binding var text: String
    
    @State private var larger = true
    
    var body: some View {
        
        
            HStack {
                TextField("Search", text: $text)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: {
                    self.text = ""
                }) {
                    Text("Clear")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 1), value: larger)
                
            }
            .padding(.horizontal)
        
    }
}
