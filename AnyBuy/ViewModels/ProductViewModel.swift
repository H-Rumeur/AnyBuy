import SwiftUI
import Supabase
import Foundation
import Storage
import Combine

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    
    func fetchProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response: [Product] = try await SupabaseManager.shared.client.database
                .from("products")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            self.products = response
        } catch {
            print("Erreur fetch: \(error.localizedDescription)")
        }
    }

    // --- CETTE FONCTION ÉTAIT MANQUANTE ICI ---
    func uploadImage(_ image: UIImage) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = "\(UUID().uuidString).jpg"
        
        do {
            let storage = SupabaseManager.shared.client.storage
            // Utilisation de la nouvelle syntaxe pour éviter le warning 'deprecated'
            try await storage.from("product-images").upload(fileName, data: imageData, options: FileOptions(contentType: "image/jpeg"))
            
            let publicURL = try storage.from("product-images").getPublicURL(path: fileName)
            return publicURL.absoluteString
        } catch {
            print("DEBUG: Erreur upload storage: \(error)")
            return nil
        }
    }

    func addProduct(product: Product) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await SupabaseManager.shared.client.database
                .from("products")
                .insert(product)
                .execute()
            
            await fetchProducts()
        } catch {
            print("Erreur ajout : \(error)")
        }
    }
    
    func deleteProduct(product: Product) async {
        guard let id = product.id else { return }
        do {
            try await SupabaseManager.shared.client.database
                .from("products")
                .delete()
                .eq("id", value: id)
                .execute()
            
            // On retire le produit de la liste locale pour mettre à jour l'UI
            self.products.removeAll { $0.id == id }
        } catch {
            print("Erreur suppression: \(error)")
        }
    }
}
