import SwiftUI
import Supabase
import Auth     // Ajoute cet import
import Combine

struct ChatDetailView: View {
    let conversation: Conversation
    let receiverId: UUID
    
    @StateObject var viewModel = ChatViewModel() // On le créera juste après
    @EnvironmentObject var authVM: AuthViewModel
    @State private var messageText = ""
    
    var body: some View {
        VStack {
            // Liste des messages ici...
        }
        .navigationTitle("Chat")
    }
}
