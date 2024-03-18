public struct MessagesError: Codable {
    enum CodingKeys: String, CodingKey {
        case statusCode
        case error
        case message
    }

    public let statusCode: Int
    public let message: [String]
    public let error: String?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let messageString = try? values.decode(String.self, forKey: .message)
        let messageStrings = try? values.decode([String].self, forKey: .message)
        guard messageString != nil || messageStrings != nil else {
            throw Errors.System.unknown
        }
        message = messageStrings ?? [messageString ?? ""]

        statusCode = try values.decode(Int.self, forKey: .statusCode)
        error = try? values.decodeIfPresent(String.self, forKey: .error)
    }
}
