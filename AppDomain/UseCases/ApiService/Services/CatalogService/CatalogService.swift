import Foundation
import Moya

// MARK: - CatalogService

enum CatalogService {
    case generateImage(GenImageParameters)
    case getGenerateModels
    case checkGenerateStatus(String)
    case getStyles
}

// MARK: - CatalogService TargetType

extension CatalogService: NetworkEndpoints {
    public var baseURL: URL {
        switch self {
        case .getStyles:
            return URL(string: "https://cdn.fusionbrain.ai")!
        default:
            return Preferences.Server.serverBaseUrl
        }
    }

    public var path: String {
        switch self {
        case .generateImage:
            return "/key/api/v1/text2image/run"
        case .getGenerateModels:
            return "/key/api/v1/models"
        case .checkGenerateStatus(let uuid):
            return "/key/api/v1/text2image/status/\(uuid)"
        case .getStyles:
            return "/static/styles/api"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .generateImage:
            return .post
        case
            .getGenerateModels,
            .checkGenerateStatus,
            .getStyles:
            return .get
        }
    }

    public var task: Moya.Task {
        var dict = [String: Any]()
        switch self {
        case .generateImage(let params):
            var parameters: [String: Any] = [
                "type": "GENERATE",
                "generateParams": [
                    "query": "море"
                ]
            ]
            parameters = params.toDictionary()
            let formData = MultipartFormData(provider: .data(try! JSONSerialization.data(withJSONObject: parameters)),
                                             name: "params",
                                             fileName: "params.json",
                                             mimeType: "application/json")
            let modelID: String = "4"
            let modelIDFormData = MultipartFormData(provider: .data(modelID.data(using: .utf8)!),
                                                    name: "model_id")
            
            return .uploadMultipart([formData, modelIDFormData])

        case
            .getGenerateModels,
            .checkGenerateStatus,
            .getStyles:
            return .requestPlain
        }
    }

    public var authorizationType: Moya.AuthorizationType? {
        nil
    }
}
