import SwiftUI
import Supabase
import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let client = SupabaseManager.shared.client
    
    // 1. Charger les messages
    func fetchMessages(for receiverId: UUID) async {
        do {
            let currentUser = try await client.auth.session.user
            
            let response: [Message] = try await client.database
                .from("messages")
                .select()
                .or("and(sender_id.eq.\(currentUser.id),receiver_id.eq.\(receiverId)),and(sender_id.eq.\(receiverId),receiver_id.eq.\(currentUser.id))")
                .order("created_at", ascending: true)
                .execute()
                .value
            
            self.messages = response
            setupRealtimeSubscription(receiverId: receiverId)
        } catch {
            print("Erreur fetch messages: \(error)")
        }
    }
    
    // 2. ENVOYER UN MESSAGE TEXTE (Celle qui manquait !)
    func sendMessage(content: String, receiverId: UUID, productId: UUID? = nil) async {
        do {
            let currentUser = try await client.auth.session.user
            let newMessage = Message(senderId: currentUser.id, receiverId: receiverId, content: content, productId: productId)
            
            try await client.database
                .from("messages")
                .insert(newMessage)
                .execute()
            
            // Note: Le Realtime rafraîchira la liste automatiquement
        } catch {
            print("Erreur envoi message: \(error)")
        }
    }
    
    // Récupérer absolument tous les messages de l'utilisateur connecté
    func fetchAllUserMessages(userId: UUID) async {
        do {
            let response: [Message] = try await client.database
                .from("messages")
                .select()
                .or("sender_id.eq.\(userId),receiver_id.eq.\(userId)")
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.messages = response
        } catch {
            print("Erreur liste messages: \(error)")
        }
    }

    // Logique pour n'afficher qu'un seul message par contact dans la liste
    func getUniqueConversations(currentUserId: UUID?) -> [Message] {
        guard let currentUserId = currentUserId else { return [] }
        var uniqueMessages: [Message] = []
        var seenUsers: Set<UUID> = []
        
        for message in messages {
            let otherUser = message.senderId == currentUserId ? message.receiverId : message.senderId
            if !seenUsers.contains(otherUser) {
                uniqueMessages.append(message)
                seenUsers.insert(otherUser)
            }
        }
        return uniqueMessages
    }
    
    // 3. Envoyer une photo
    func sendPhotoMessage(image: UIImage, receiverId: UUID) async {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let fileName = "chat/\(UUID().uuidString).jpg"
        
        do {
            try await client.storage.from("product-images").upload(fileName, data: data)
            let publicURL = try client.storage.from("product-images").getPublicURL(path: fileName)
            
            let currentUser = try await client.auth.session.user
            let newMessage = Message(senderId: currentUser.id, receiverId: receiverId, content: nil, imageUrl: publicURL.absoluteString)
            
            try await client.database.from("messages").insert(newMessage).execute()
        } catch {
            print("Erreur envoi photo: \(error)")
        }
    }
    
    // 4. Temps réel
    private func setupRealtimeSubscription(receiverId: UUID) {
        let channel = client.realtime.channel("chat_channel")
        
        channel.on("postgres_changes", filter: .init(event: "INSERT", schema: "public", table: "messages")) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchMessages(for: receiverId)
            }
        }
        
        channel.subscribe()
    }
}
