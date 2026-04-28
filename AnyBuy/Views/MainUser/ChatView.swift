import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    let receiverId: UUID
    let receiverName: String
    
    @State private var messageText = ""

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            chatBubble(message: message)
                                .id(message.id) // ID placé sur la bulle pour le scroll
                        }
                    }
                    .padding()
                }
                // Nouvelle syntaxe iOS 17+ pour onChange
                .onChange(of: viewModel.messages.count) {
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                Button(action: { /* Action Photo */ }) {
                    Image(systemName: "photo")
                        .font(.title2)
                }
                
                TextField("Message...", text: $messageText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle(receiverName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { await viewModel.fetchMessages(for: receiverId) }
        }
    }

    @ViewBuilder
    func chatBubble(message: Message) -> some View {
        let isCurrentUser = message.senderId == authVM.currentUser?.id
        
        HStack {
            if isCurrentUser { Spacer() }
            
            // Affichage texte ou image
            if let imageUrl = message.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFit()
                } placeholder: { ProgressView() }
                .frame(maxWidth: 200)
                .cornerRadius(10)
            } else {
                Text(message.content ?? "")
                    .padding(12)
                    .background(isCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .cornerRadius(15)
            }
            
            if !isCurrentUser { Spacer() }
        }
    }

    func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        Task {
            await viewModel.sendMessage(content: trimmedText, receiverId: receiverId)
            messageText = ""
        }
    }
}
