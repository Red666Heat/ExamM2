import Alamofire
import Foundation

final class CatalogServiceProviderImpl: Provider<CatalogService>, CatalogServiceProvider {
    func generateImage(
        parameters: GenImageParameters,
        callback: @escaping (Result<StartGenerateResponse, Error>) -> Void
    ) {
        requestData(target: .generateImage(parameters), callback: callback)
    }

    func getGenerateModels(callback: @escaping (Result<Empty, Error>) -> Void) {
        requestVoid(target: .getGenerateModels, callback: callback)
    }

    func checkGenerateImage(
        uuid: String,
        callback: @escaping (Result<GenerateResponse, Error>) -> Void
    ) {
        requestData(target: .checkGenerateStatus(uuid), callback: callback)
    }

    func getStyles(callback: @escaping (Result<[StyleModel], Error>) -> Void) {
        requestData(target: .getStyles, callback: callback)
    }
}
