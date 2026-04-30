import Foundation

struct Profile: Codable, Identifiable {
    let id: UUID
    var firstName: String?
    var lastName: String?
    var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }
    
    var fullName: String {
        "\(firstName ?? "") \(lastName ?? "")".trimmingCharacters(in: .whitespaces)
    }
}
