import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                // On filtre pour n'afficher que les conversations uniques
                // (C'est une version simplifiée pour commencer)
                if viewModel.messages.isEmpty {
                    ContentUnavailableView("Aucun message", systemImage: "bubble.left.and.bubble.right", description: Text("Vos conversations apparaîtront ici."))
                } else {
                    List(viewModel.getUniqueConversations(currentUserId: authVM.currentUser?.id), id: \.id) { lastMsg in
                        let interlocutorId = lastMsg.senderId == authVM.currentUser?.id ? lastMsg.receiverId : lastMsg.senderId
                        
                        NavigationLink(destination: ChatView(receiverId: interlocutorId, receiverName: "Utilisateur")) {
                            HStack(spacing: 15) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue.opacity(0.7))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Contact") // Plus tard, on récupérera le vrai nom
                                        .font(.headline)
                                    
                                    Text(lastMsg.content ?? "Photo")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .onAppear {
                Task {
                    // Ici on récupère TOUS les messages de l'utilisateur pour construire la liste
                    if let userId = authVM.currentUser?.id {
                        await viewModel.fetchAllUserMessages(userId: userId)
                    }
                }
            }
        }
    }
}
