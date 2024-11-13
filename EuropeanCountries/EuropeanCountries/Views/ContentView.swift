import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager: CountryManager
    @State private var searchText = ""
    
    // Filtered Lists
    var euCountries: [Country] {
        manager.countries.filter { $0.isMember }
    }
    
    var nonEuCountries: [Country] {
        manager.countries.filter { !$0.isMember }
    }
    
    var filteredEuCountries: [Country] {
        filterCountries(euCountries)
    }
    
    var filteredNonEuCountries: [Country] {
        filterCountries(nonEuCountries)
    }
    
    // Enum for Tabs
    enum Tab: Hashable {
        case europeanCountries
        case information
        
        var title: String {
            switch self {
            case .europeanCountries:
                return "European Countries"
            case .information:
                return "Information"
            }
        }
        
        var systemImage: String {
            switch self {
            case .europeanCountries:
                return "globe.europe.africa.fill"
            case .information:
                return "info.circle"
            }
        }
    }
    
    @State private var selectedTab: Tab = .europeanCountries
    
    var body: some View {
        NavigationStack {
            VStack {
                // Conditionally show the SearchBar only in the European Countries tab
                if selectedTab == .europeanCountries {
                    SearchBar(text: $searchText)
                        .padding(.top)
                }
                
                TabView(selection: $selectedTab) {
                    
                    // European Countries Tab
                    List {
                        if !filteredEuCountries.isEmpty {
                            Section(header: Text("EU Members")) {
                                ForEach(filteredEuCountries) { country in
                                    CountryRow(country: country)
                                }
                            }
                        }
                        
                        if !filteredNonEuCountries.isEmpty {
                            Section(header: Text("Non-members")) {
                                ForEach(filteredNonEuCountries) { country in
                                    CountryRow(country: country)
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .tabItem {
                        Label(Tab.europeanCountries.title, systemImage: Tab.europeanCountries.systemImage)
                    }
                    .tag(Tab.europeanCountries)
                    
                    // Information Tab
                    InfoScreen()
                        .tabItem {
                            Label(Tab.information.title, systemImage: Tab.information.systemImage)
                        }
                        .tag(Tab.information)
                }
                .navigationTitle(selectedTab.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // Helper Function to Filter Countries
    private func filterCountries(_ countries: [Country]) -> [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}


import SwiftUI

struct CountryRow: View {
    let country: Country
    
    var body: some View {
        NavigationLink(destination: CountryView(country: country)) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(country.name)
                        .font(.headline)
                    
                    HStack(spacing: 10) {
                        MembershipView(country: country)
                    }
                }
                Spacer()
                Image(country.code.lowercased())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 30)
                    .cornerRadius(5)
                    .shadow(radius: 2)
            }
            .padding(.vertical, 8)
        }
    }
}


#Preview {
    ContentView().environmentObject(CountryManager())
}

struct InfoScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Header
                HeaderView()
                
                // Eurozone Membership Section
                InfoSection(
                    title: "Eurozone Membership",
                    items: [
                        InfoItem(
                            icon: "eurosign.square.fill",
                            iconColor: .blue,
                            text: "Country is part of the Eurozone (€)",
                            backgroundColor: Color.blue.opacity(0.1)
                        ),
                        InfoItem(
                            icon: "eurosign.square.fill",
                            iconColor: .gray,
                            text: "Country is NOT part of the Eurozone (€)",
                            backgroundColor: Color.gray.opacity(0.1)
                        )
                    ]
                )
                
                // Schengen Agreement Section
                InfoSection(
                    title: "Schengen Agreement",
                    items: [
                        InfoItem(
                            icon: "star.fill",
                            iconColor: .yellow,
                            text: "Country is part of the Schengen Agreement",
                            backgroundColor: Color.yellow.opacity(0.1)
                        ),
                        InfoItem(
                            icon: "star.fill",
                            iconColor: .gray,
                            text: "Country is NOT part of the Schengen Agreement",
                            backgroundColor: Color.gray.opacity(0.1)
                        )
                    ]
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .padding(.top, 10) // Add top padding to avoid navigation bar
        .edgesIgnoringSafeArea(.bottom) // Ensure only bottom edges ignore safe area if needed
    }
}


struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Country Information")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Understand the membership and agreements that define European countries.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct InfoSection: View {
    let title: String
    let items: [InfoItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            ForEach(items) { item in
                InfoRow(item: item)
            }
        }
    }
}

struct InfoItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let text: String
    let backgroundColor: Color
}

struct InfoRow: View {
    let item: InfoItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: item.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(item.iconColor)
                .padding(8)
                .background(item.backgroundColor)
                .cornerRadius(8)
            
            Text(item.text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search countries...", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel("Clear search text")
            }
        }
        .padding(10)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
