import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss // Permet de revenir au Login après inscription
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Créer un compte")
                        .font(.largeTitle).bold()
                    Text("Rejoignez AnyBuy et commencez à vendre")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Formulaire
                VStack(spacing: 15) {
                    TextField("Nom complet", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                // Bouton d'inscription
                // On retire le $ devant authVM et on utilise le nom 'register'
                Button {
                    Task {
                        await authVM.register(email: email, pass: password, name: fullName)
                    }
                } label: {
                    if authVM.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("S'inscrire")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .disabled(email.isEmpty || password.count < 6 || fullName.isEmpty)
                
                Spacer()
                
                // Lien vers le Login
                Button("Déjà un compte ? Se connecter") {
                    dismiss()
                }
                .font(.footnote)
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Erreur", isPresented: $isShowingAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(authVM.errorMessage ?? "Une erreur est survenue")
            })
            // On surveille si une erreur arrive pour l'afficher
            .onChange(of: authVM.errorMessage) { _ in
                if authVM.errorMessage != nil {
                    isShowingAlert = true
                }
            }
        }
    }
}
