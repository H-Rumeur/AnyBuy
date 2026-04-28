import Foundation

struct Conversation: Identifiable, Codable {
    var id: UUID?
    let productId: UUID
    let buyerId: UUID
    let sellerId: UUID
    var lastMessage: String?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case buyerId = "buyer_id"
        case sellerId = "seller_id"
        case lastMessage = "last_message"
        case updatedAt = "updated_at"
    }
}
