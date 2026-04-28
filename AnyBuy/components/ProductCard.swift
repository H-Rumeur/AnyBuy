import SwiftUI

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { // Spacing à 0 ici
            
            // --- 1. GESTION STRICTE DE L'IMAGE ---
            // On s'assure que l'image remplit la zone SANS déborder
            // --- 1. GESTION STRICTE DE LA LARGEUR ET HAUTEUR ---
            AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill() // Remplit la case sans déformer
                    .frame(minWidth: 0, maxWidth: .infinity) // Prend TOUTE la largeur de la colonne
                    .frame(height: 140) // Garde une hauteur fixe
                    .clipped() // COUPE tout ce qui dépasse des limites de la case (Indispensable !)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 140)
                    .overlay(ProgressView())
            }
            .cornerRadius(12, corners: [.topLeft, .topRight]) // Coin arrondis uniquement en haut
            
            // --- 2. CONTENU DU BAS AVEC HAUTEUR CONTRÔLÉE ---
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1) // Évite que le titre ne prenne 2 lignes et ne pousse tout
                
                Text("\(String(format: "%.2f", product.price)) €")
                    .font(.subheadline)
                    .fontWeight(.black)
                    .foregroundColor(.blue)
                
                Text(product.category)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1) // Évite les débordements ici aussi
            }
            .padding(10)
            // C'est cette ligne qui résout le problème de superposition !
            // En donnant une hauteur minimale au contenu textuel, toutes les cartes auront la même taille totale.
            .frame(height: 75, alignment: .top)
            .background(Color(.systemBackground))
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight]) // Coin arrondis en bas
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
}

// --- PETIT HELPER POUR LES COINS ARRONDIS ---
// Copie ceci à la fin de ton fichier ProductCard.swift
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
