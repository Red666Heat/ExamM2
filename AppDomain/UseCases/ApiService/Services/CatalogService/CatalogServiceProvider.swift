import Alamofire

public protocol CatalogServiceProvider: AnyObject {
    func generateImage(
        parameters: GenImageParameters,
        callback: @escaping (Result<StartGenerateResponse, Error>) -> Void
    )

    func getGenerateModels(
        callback: @escaping (Result<Empty, Error>) -> Void
    )

    func checkGenerateImage(
        uuid: String,
        callback: @escaping (Result<GenerateResponse, Error>) -> Void
    )

    func getStyles(
        callback: @escaping (Result<[StyleModel], Error>) -> Void
    )
}
