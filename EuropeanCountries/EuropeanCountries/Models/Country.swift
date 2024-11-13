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
    

        var formattedPopulation: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = " "
            formatter.groupingSize = 3
            formatter.usesGroupingSeparator = true
            return formatter.string(from: NSNumber(value: population)) ?? "\(population)"
        }
    
        var formattedArea: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: area)) ?? "\(area)"
    }
    
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
