import SwiftUI

struct MyProductsView: View {
    @StateObject var viewModel = ProductViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        List {
            // On ne garde que les produits dont l'ownerId correspond à l'utilisateur connecté
            let myProducts = viewModel.products.filter { $0.ownerId == authVM.currentUser?.id }
            
            if myProducts.isEmpty {
                Text("Vous n'avez publié aucune annonce.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(myProducts) { product in
                    HStack {
                        AsyncImage(url: URL(string: product.imageUrl ?? "")) { img in
                            img.resizable().scaledToFill()
                        } placeholder: { Color.gray }
                        .frame(width: 50, height: 50).cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(product.title).font(.headline)
                            Text("\(String(format: "%.2f", product.price)) €").font(.subheadline)
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
}
