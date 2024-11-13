import Foundation

class CountryManager: ObservableObject {
    
    @Published var countries: [Country]
    
    init() {
        self.countries = []
        self.loadCountries()
    }
    
    
    let urlString = "http://localhost:3000/api/countries"
    
    private func loadCountries() {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedCountries = try JSONDecoder().decode([Country].self, from: data)
                    DispatchQueue.main.async {
                        self.countries = decodedCountries
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }.resume()
    }
    
}

