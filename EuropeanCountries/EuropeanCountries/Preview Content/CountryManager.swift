//
//  CountryManager.swift
//  EuropeanCountries
//
//  Created by Anton Lahtinen on 17.5.2023.
//

import Foundation

class CountryManager: ObservableObject {
    
    @Published var countries: [Country]
    
    init() {
        
        self.countries = []
        
        self.loadCountriesWithURLSession()
    }
    
    
    let urlString = ""
    
    private func loadCountriesWithURLSession() {
        if let url = URL(string: urlString) {
            print("About to hit lambda function URL to get countries (URLSession)")
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let jsonData = data {
                    let decoder = JSONDecoder()
                    if let countries = try? decoder.decode([Country].self, from: jsonData) {
                        print("Countries loaded from lambda function URL (URLSession)")
                        
                        DispatchQueue.main.async {
                            self.countries = []
                        }
   
                        
                        for country in countries {
                            DispatchQueue.main.async {
                                self.countries.append(country)
                            }
                            Thread.sleep(forTimeInterval: 0)
                        }
                    }
                    else {
                        print("Error parsing JSON data")
                    }
                } else if let error = error {
                    print("Unable to retrieve JSON data, error: \(error)")
                }
            }
            task.resume()  // Remember this
        }
        else {
            print("Bad URL")
        }
    }
    
}

