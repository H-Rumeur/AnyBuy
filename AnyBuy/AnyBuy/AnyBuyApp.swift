import SwiftUI
import Combine // <-- AJOUTE CETTE LIGNE

@main
struct AnyBuyApp: App {
    // Cela devrait maintenant fonctionner sans erreur
    @StateObject var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainRouterView()
                .environmentObject(authVM)
        }
    }
}
