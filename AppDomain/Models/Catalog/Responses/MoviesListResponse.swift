public struct MoviesListResponse: Codable {
    public let meta: Paginator?
    public let data: [Movie]?
}
