import SwiftUI

struct MainUserTabView: View {
    var body: some View {
        TabView {
            // Onglet 1 : Accueil (Grille de produits)
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house")
                }
            
            // --- NOUVEL ONGLET : LA CARTE ---
            ExploreMapView()
                .tabItem {
                    Label("Explorer", systemImage: "map")
                }
            
            // Onglet 3 : Messages
            ChatListView()
                .tabItem {
                    Label("Messages", systemImage: "bubble.left.and.bubble.right")
                }
            
            // Onglet 4 : Profil
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
    }
}
