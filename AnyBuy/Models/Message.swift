import Foundation

struct Message: Identifiable, Codable {
    var id: UUID?
    var createdAt: Date?
    var senderId: UUID
    var receiverId: UUID
    var content: String?
    var imageUrl: String?
    var productId: UUID?

    enum CodingKeys: String, CodingKey {
        case id, content
        case createdAt = "created_at"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case imageUrl = "image_url"
        case productId = "product_id"
    }
}
