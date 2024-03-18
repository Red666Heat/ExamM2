public struct Paginator: Codable, Equatable {
    public var page: Int
    public let limit: Int
    public var amountItems: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case limit
        case amountItems = "amount_items"
    }

    public init(page: Int, limit: Int = 20) {
        self.page = page
        self.limit = limit
    }

    public func getParams() -> [String: Any] {
        return [
            "page": self.page,
            "limit": self.limit
        ]
    }
}
