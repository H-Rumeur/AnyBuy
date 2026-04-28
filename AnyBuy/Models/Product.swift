import Foundation

struct Product: Identifiable, Codable {
    var id: UUID?
    var ownerId: UUID
    var title: String
    var description: String
    var price: Double
    var category: String
    var imageUrl: String?
    var latitude: Double?
    var longitude: Double?
    var maxPeople: Int?        // Ajouté pour tes nouveaux besoins
    var createdAt: Date?

    // CodingKeys : fait le lien entre JSON (Supabase) et Swift
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id" // Indispensable si ta colonne SQL est owner_id
        case title
        case description
        case price
        case category
        case imageUrl = "image_url"
        case latitude
        case longitude
        case maxPeople = "max_people"
        case createdAt = "created_at"
    }
}
