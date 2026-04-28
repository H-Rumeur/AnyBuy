import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var session: Session?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var client = SupabaseManager.shared.client

    init() {
            Task {
                do {
                    // On récupère la session de manière asynchrone
                    let currentSession = try await client.auth.session
                    
                    // On met à jour la variable @Published sur le thread principal
                    self.session = currentSession
                    
                    // On accède directement à user (sans le ?) car on sait qu'il est là
                    // si la session est valide
                    let userId = currentSession.user.id
                    await fetchProfile(id: userId)
                    
                } catch {
                    // Si aucune session n'est trouvée, try await renvoie une erreur
                    // ou une session vide. On gère ça sans crash.
                    print("Info: Aucune session active au démarrage.")
                }
            }
        }

    func register(email: String, pass: String, name: String) async {
        isLoading = true
        errorMessage = nil // Reset l'erreur
        do {
            // 1. Inscription dans auth.users
            let authResponse = try await client.auth.signUp(email: email, password: pass)
            
            // 2. Création du profil dans public.profiles
            let newUser = AppUser(id: authResponse.user.id, email: email, fullName: name, isAdmin: false)
            
            try await client.database
                .from("profiles")
                .insert(newUser)
                .execute()
            
            self.session = authResponse.session
            self.currentUser = newUser
            
        } catch {
            errorMessage = "Erreur d'inscription : \(error.localizedDescription)"
        }
        isLoading = false
    }

    func signIn(email: String, pass: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let session = try await client.auth.signIn(email: email, password: pass)
            self.session = session
            await fetchProfile(id: session.user.id)
        } catch {
            errorMessage = "Erreur de connexion : \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func signOut() async {
        do {
            try await client.auth.signOut()
            self.session = nil
            self.currentUser = nil
        } catch {
            print("Erreur de déconnexion")
        }
    }
    
    func fetchProfile(id: UUID) async {
        do {
            let user: AppUser = try await client.database
                .from("profiles")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            self.currentUser = user
        } catch {
            print("Erreur de récupération de profil: \(error)")
        }
    }
}
