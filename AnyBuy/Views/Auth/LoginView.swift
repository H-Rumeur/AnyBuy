import SwiftUI

struct LoginView: View {
    @StateObject var authVM = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack { // <--- Important pour pouvoir naviguer
            VStack(spacing: 20) {
                Text("Connexion")
                    .font(.largeTitle).bold()
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                Button {
                    Task {
                        await authVM.signIn(email: email, pass: password)
                    }
                } label: {
                    Text("Se connecter")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // --- LE TEXTE CLIQUABLE AJOUTÉ ICI ---
                NavigationLink {
                    RegisterView() // <--- Destination
                } label: {
                    HStack {
                        Text("Pas encore de compte ?")
                            .foregroundColor(.gray)
                        Text("S'inscrire")
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }
                // -------------------------------------
                
                Spacer()
            }
        }
    }
}
