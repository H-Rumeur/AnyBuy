import SwiftUI

struct MyAdsView: View {
    @StateObject var viewModel = ProductViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        List {
            // Filtrage : uniquement les produits de l'utilisateur connecté
            let myProducts = viewModel.products.filter { $0.ownerId == authVM.currentUser?.id }
            
            if myProducts.isEmpty {
                ContentUnavailableView("Aucune annonce", systemImage: "house", description: Text("Vous n'avez pas encore publié d'annonces."))
            } else {
                ForEach(myProducts) { product in
                    HStack(spacing: 15) {
                        AsyncImage(url: URL(string: product.imageUrl ?? "")) { img in
                            img.resizable().scaledToFill()
                        } placeholder: { Color.gray.opacity(0.2) }
                        .frame(width: 60, height: 60).cornerRadius(8).clipped()
                        
                        VStack(alignment: .leading) {
                            Text(product.title).font(.headline)
                            Text("\(String(format: "%.2f", product.price)) €").font(.subheadline).foregroundColor(.blue)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteAd(product: product)
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Mes Annonces")
        .onAppear {
            Task { await viewModel.fetchProducts() }
        }
    }
    
    func deleteAd(product: Product) {
        Task {
            // On appellera une fonction delete dans le ViewModel
            // await viewModel.deleteProduct(product: product)
        }
    }
}
