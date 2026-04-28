//
//  MyProductsView.swift
//  AnyBuy
//
//  Created by User on 17/04/26.
//

import SwiftUI

struct MyProductsView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    // On filtre pour n'afficher que les annonces de l'utilisateur (ou tout pour l'admin)
    var filteredProducts: [Product] {
        if viewModel.isUserAdmin {
            return viewModel.products
        } else {
            return viewModel.products.filter { $0.sellerId == viewModel.currentUserID }
        }
    }
    
    var body: some View {
        List {
            if filteredProducts.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("Non hai ancora pubblicato annunci.")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .listRowBackground(Color.clear)
            } else {
                ForEach(filteredProducts) { product in
                    HStack(spacing: 15) {
                        // Petite miniature
                        Image(systemName: product.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(product.title).font(.headline)
                            Text("\(String(format: "%.2f", product.price))€")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        // Menu contextuel pour Modifier/Supprimer
                        Menu {
                            Button(action: { /* Logique Edit */ }) {
                                Label("Modifica", systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                viewModel.deleteProduct(product: product)
                            }) {
                                Label("Elimina", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(viewModel.isUserAdmin ? "Tutti gli Annunci" : "I miei Annunci")
        .navigationBarTitleDisplayMode(.inline)
    }
}
