import Foundation

struct AppUser: Identifiable, Codable {
    let id: UUID
    let email: String
    var fullName: String?
    var avatarUrl: String?
    var isAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case isAdmin = "is_admin"
    }
}
