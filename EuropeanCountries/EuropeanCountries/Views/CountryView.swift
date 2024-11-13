import SwiftUI
import MapKit

struct CountryView: View {
    // MARK: - Properties
    let country: Country
    @Environment(\.openURL) private var openURL
    @State private var coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var region: MKCoordinateRegion
    @State private var isLoading = true // To manage loading state
    
    // MARK: - Initialization
    init(country: Country) {
        self.country = country
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 7.0, longitudeDelta: 5.0)
        ))
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Map Section (55% of screen height)
                mapSection
                    .frame(height: geometry.size.height * 0.55)
                
                // Content Section
                ScrollView {
                    VStack(spacing: 24) {
                        // Country Name and Flag
                        VStack(spacing: 16) {
                            Text(country.name)
                                .font(.system(.title, design: .rounded, weight: .bold))
                                .multilineTextAlignment(.center)
                            
                            flagSection
                                .frame(height: 120)
                        }
                        .padding(.top, 24)
                        
                        // Details
                        CountryDetailsView(country: country)
                            .padding(.horizontal)
                        
                        // Wikipedia Button
                        wikipediaButton
                            .padding(.horizontal, 40)
                            .padding(.bottom)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .overlay(
                // Loading Indicator
                Group {
                    if isLoading {
                        ProgressView("Loading Map...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await geocodeCountry()
        }
    }
    
    // MARK: - UI Components
    private var mapSection: some View {
        Map(coordinateRegion: $region, annotationItems: [country]) { country in
            MapMarker(coordinate: coordinates, tint: .red)
        }
        
    }
    
    private var flagSection: some View {
        Image(country.code.lowercased())
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(radius: 10, x: 0, y: 5)
            .padding(.horizontal, 40)
            .accessibilityLabel("\(country.name) Flag")
    }
    
    private var wikipediaButton: some View {
        Button(action: openWikipedia) {
            HStack {
                Image(systemName: "book.fill")
                    .imageScale(.medium)
                Text("Learn More on Wikipedia")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.blue.gradient)
            )
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .accessibilityHint("Opens the Wikipedia page for \(country.name)")
    }
    
    // MARK: - Helper Methods
    private func openWikipedia() {
        let urlString: String
        switch country.name {
        case "United Kingdom":
            urlString = "https://en.wikipedia.org/wiki/United_Kingdom"
        case "Czech Republic":
            urlString = "https://en.wikipedia.org/wiki/Czech_Republic"
        default:
            let encodedName = country.name.replacingOccurrences(of: " ", with: "_")
            urlString = "https://en.wikipedia.org/wiki/\(encodedName)"
        }
        
        if let url = URL(string: urlString) {
            openURL(url)
        }
    }
    
    private func geocodeCountry() async {
        let geocoder = CLGeocoder()
        do {
            if let placemark = try await geocoder.geocodeAddressString(country.name).first,
               let location = placemark.location {
                coordinates = location.coordinate
                print("Geocoded Coordinates: \(coordinates.latitude), \(coordinates.longitude)") // For debugging
                
                // Update the region to center on the geocoded coordinates
                await MainActor.run {
                    withAnimation {
                        region = MKCoordinateRegion(
                            center: coordinates,
                            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
                        )
                        isLoading = false
                    }
                }
            } else {
                // Handle no placemark found
                print("No placemark found for country: \(country.name)")
                await MainActor.run {
                    isLoading = false
                }
            }
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

#Preview {

    CountryView(country: finland)
}
