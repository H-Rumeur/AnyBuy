import SwiftUI
import MapKit

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // --- 1. IMAGE RESPONSIVE ---
                    AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width)
                            .frame(minHeight: 300, maxHeight: 450)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 350)
                            .overlay(ProgressView())
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // --- 2. INFOS PRINCIPALES ---
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.category)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(5)
                                
                                Text(product.title)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Text("\(String(format: "%.2f", product.price)) €")
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        // --- 3. DESCRIPTION ---
                        Text("Description")
                            .font(.headline)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        // --- 4. LOCALISATION (Petit badge) ---
                        if product.latitude != nil {
                            Label("Paris, France", systemImage: "mappin.and.ellipse")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Espace pour ne pas être caché par le bouton fixe
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // --- 5. STICKY BOTTOM BAR (Actions) ---
            VStack {
                Divider()
                HStack(spacing: 15) {
                    // Bouton Message
                    NavigationLink(destination: ChatView(receiverId: product.ownerId, receiverName: "Vendeur")) {
                        Text("Contacter le vendeur")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    // Bouton Acheter
                    Button(action: { /* Action achat */ }) {
                        Text("Acheter maintenant")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30) // S'adapte à la zone sécurisée du bas
                .background(.ultraThinMaterial) // Effet flou derrière les boutons
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar) // Cache la barre de navigation au scroll
    }
}
