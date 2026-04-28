import SwiftUI

struct MessagesView: View {
    // 1. Accès à l'utilisateur connecté pour savoir qui est "l'autre" dans le chat
    @EnvironmentObject var authVM: AuthViewModel
    
    // 2. À lier plus tard avec un ChatViewModel pour charger les vraies données
    @State private var conversations: [Conversation] = []
    
    var body: some View {
        NavigationStack {
            List(conversations) { conversation in
                // 3. Calcul du destinataire : si l'acheteur c'est moi, alors le destinataire est le vendeur, et inversement
                let receiverId = (conversation.buyerId == authVM.currentUser?.id) ? conversation.sellerId : conversation.buyerId
                
                NavigationLink(destination: ChatDetailView(conversation: conversation, receiverId: receiverId)) {
                    HStack(spacing: 15) {
                        // Avatar avec initiales ou icône
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Discussion") // On pourra afficher le nom du produit ou de l'user plus tard
                                .font(.headline)
                            
                            Text(conversation.lastMessage ?? "Commencer la discussion")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        // Petit indicateur de date si disponible
                        if let date = conversation.updatedAt {
                            Text(date, style: .time)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
            .overlay {
                if conversations.isEmpty {
                    ContentUnavailableView(
                        "Aucun message",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Vos discussions avec les vendeurs et acheteurs apparaîtront ici.")
                    )
                }
            }
        }
    }
}
