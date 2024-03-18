public struct Movie: Codable {
    public let id: Int
    public let name: String?
    public let shortDescription: String?
    public let description: String?
    public let rating: Float?
    public let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortDescription = "short_description"
        case description
        case rating
        case imageUrl = "image_url"
    }
}
