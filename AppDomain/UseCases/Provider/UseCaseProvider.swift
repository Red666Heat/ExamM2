public protocol UseCaseProvider: AnyObject {
    // MARK: - Functions

    func makeApiService() -> ApiService
}
