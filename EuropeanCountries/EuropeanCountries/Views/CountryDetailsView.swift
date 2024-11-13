import SwiftUI

struct CountryDetailsView: View {
    
    var country: Country
    
    var body: some View {
        VStack(spacing: 20) {
            MembershipView(country: country)
                .font(.system(size: 30))
            
            HStack(spacing: 40){
                DetailItem(title: "Area", value: "\(country.formattedArea) km²", systemImage: "map")
                DetailItem(title: "Population", value: "\(country.formattedPopulation)", systemImage: "person.2.fill")
                DetailItem(title: "Density", value: "\(country.populationDensity) /km²", systemImage: "figure.stand.line.dotted.figure.stand")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct DetailItem: View {
    let title: String
    let value: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
        CountryDetailsView(country: finland)
    }


