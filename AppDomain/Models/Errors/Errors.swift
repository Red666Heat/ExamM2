public enum Errors {
    /// Сетевые ошибки.
    public enum Network: GMError {
        case noInternet
        case serverUnavailable
    }

    /// Сервер сообщил об ошибке в ответе запроса.
    public enum Server: GMError {
        case error(MessagesError)
        case timeoutError
    }

    /// Прочие ошибки
    public enum System: GMError {
        case unknown
    }

    // swiftlint:disable:next type_name
    public enum App: GMError {
        case custom(String)
    }
}

public extension Errors.App {
    var errorDescription: String? {
        switch self {
        case .custom(let text):
            return text
        }
    }
}

public extension Errors.Network {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return ErrorMessage.noInternet

        case .serverUnavailable:
            return ErrorMessage.serverUnavailable
        }
    }
}

public extension Errors.Server {
    var errorDescription: String? {
        switch self {
        case .timeoutError:
            return ErrorMessage.timeoutError

        case let .error(error):
            var messages = [String]()
            #if DEBUG
            if let error = error.error {
                messages.append(error)
            }
            messages.append("\(error.statusCode)")
            #endif
            messages += error.message
            return messages.joined(separator: "\n")
        }
    }
}

public extension Errors.System {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return ErrorMessage.unknown
        }
    }
}
