import SwiftUI
import MapKit

struct ExploreMapView: View {
    @StateObject var viewModel = ProductViewModel()
    // Position par défaut (Paris)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.products) { product in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: product.latitude ?? 0,
                    longitude: product.longitude ?? 0
                )) {
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        VStack(spacing: 0) {
                            Text("\(Int(product.price))€")
                                .font(.caption2).bold()
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            
                            Image(systemName: "house.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationTitle("Explorer")
            .onAppear {
                Task { await viewModel.fetchProducts() }
            }
        }
    }
}
