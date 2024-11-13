import SwiftUI

struct MembershipView: View {
    var country: Country
    
    var body: some View {
        HStack(spacing: 10) {
            // Eurozone Icon
            Image(systemName: "eurosign.square.fill")
                .foregroundColor(country.isEuroZone ? .blue : .gray)
                .accessibilityLabel(country.isEuroZone ? "Part of the Eurozone" : "Not part of the Eurozone")
            
            // Schengen Icon
            Image(systemName: "star.fill")
                .foregroundColor(country.isSchengen ? .yellow : .gray)
                .accessibilityLabel(country.isSchengen ? "Part of the Schengen Agreement" : "Not part of the Schengen Agreement")
        }
        .font(.title2)
    }
}




#Preview {
    ContentView().environmentObject(CountryManager())
}
