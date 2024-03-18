import Alamofire
import Foundation
import Moya

open class Provider<Endpoint: NetworkEndpoints>: NSObject {
    // MARK: - Errors
    
    private let provider: MoyaProvider<Endpoint>

    public init(sessionConf: URLSessionConfiguration, plugins: [PluginType]) {
        provider = .init(
            session: Session(configuration: sessionConf),
            plugins: plugins
        )
    }

    func handleServerError(_ result: Result<Response, MoyaError>) throws -> Response {
        let response = try result.get()

        if let resp = try? response.filterSuccessfulStatusCodes() {
            return resp
        }

        let reqError: MessagesError? = try? JSONDecoder().decode(MessagesError.self, from: response.data)
        guard let error = reqError else {
            throw Errors.Network.serverUnavailable
        }

        throw Errors.Server.error(error)
    }

    func handleError(_ error: Swift.Error) throws {
        debugPrint(error)

        switch error {
        case is GMError:
            throw error

        case let moyaError as MoyaError:
            if let error = handle(moyaError: moyaError) {
                throw error
            }

        case let nsError as NSError:
            if let error = handle(nsError: nsError) {
                throw error
            }
        }

        throw Errors.System.unknown
    }

    func handle(moyaError: MoyaError) -> Error? {
        switch moyaError {
        case .underlying(let afError as AFError, _):
            if let nsError = afError.underlyingError as? NSError {
                return handle(nsError: nsError)
            }

        default:
            break
        }
        return nil
    }

    func handle(nsError: NSError) -> Error? {
        switch nsError.code {
        case NSURLErrorTimedOut:
            return Errors.Server.timeoutError

        case
            NSURLErrorNotConnectedToInternet,
            NSURLErrorNetworkConnectionLost:
            return Errors.Network.noInternet

        case
            NSURLErrorCannotFindHost,
            NSURLErrorCannotConnectToHost:
            return Errors.Network.serverUnavailable

        default:
            return nil
        }
    }

    func requestData<Response: Decodable>(
        target: Endpoint,
        callback: @escaping (Result<Response, Error>) -> Void
    ) {
        provider.request(target) { result in
            do {
                let response = try self.handleServerError(result)
                let responseDecoded = try response.map(Response.self)
                callback(.success(responseDecoded))
            } catch {
                callback(.failure(error))
            }
        }
    }

    func requestVoid(
        target: Endpoint,
        callback: @escaping (Result<Empty, Error>) -> Void
    ) {
        requestData(target: target, callback: callback)
    }
}
