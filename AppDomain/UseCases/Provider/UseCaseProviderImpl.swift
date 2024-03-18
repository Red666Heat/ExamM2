final class UseCaseProviderImpl: UseCaseProvider {
    // MARK: - Private Properties

    private lazy var apiService: ApiService = {
        ApiServiceImpl()
    }()

    // MARK: - Public Methods

    func makeApiService() -> ApiService {
        apiService
    }
}
