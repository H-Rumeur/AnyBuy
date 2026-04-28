import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack { // Important pour que le clic fonctionne
            List {
                Section {
                    // L'en-tête du profil avec le nom de l'utilisateur
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            Text(authVM.currentUser?.fullName ?? "Utilisateur")
                                .font(.headline)
                            Text(authVM.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Mon activité") {
                    // --- LIEN VERS TES ANNONCES ---
                    NavigationLink(destination: MyAdsView()) {
                        Label("Mes annonces", systemImage: "tag.fill")
                    }
                    
                    NavigationLink(destination: Text("Mes favoris")) {
                        Label("Favoris", systemImage: "heart.fill")
                    }
                }
                
                Section("Paramètres") {
                    Button(role: .destructive) {
                        // On crée un contexte asynchrone pour l'appel
                        Task {
                            await authVM.signOut()
                        }
                    } label: {
                        Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}
