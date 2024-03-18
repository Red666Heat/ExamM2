import Alamofire
import Foundation
import Moya
import UIKit

final class ApiServiceImpl: ApiService {
    // MARK: - Services

    /// Каталог
    lazy var catalogService: CatalogServiceProvider = CatalogServiceProviderImpl(
        sessionConf: self.sessionConf,
        plugins: self.plugins
    )

    // MARK: - Private Properties
    
    /// Сессия
    private var sessionConf: URLSessionConfiguration {
        let conf = URLSessionConfiguration.af.default
        conf.headers = HTTPHeaders([
            .userAgent(defaultUserAgent()),
            .accept("application/json"),
            .defaultAcceptLanguage
        ])
        return conf
    }

    /// Плагины
    private var plugins: [PluginType] = []

    // MARK: - Init

    init() {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)),
            URLRequestTunerPlugin()
        ]
        self.plugins = plugins
    }

    // MARK: - Private Methods

    private func defaultUserAgent() -> String {
        let bundleExecutable = Bundle.main.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) as? String
        let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String

        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String

        let phoneModel = UIDevice.current.model

        let systemVersion = UIDevice.current.systemVersion

        let scale = UIScreen.main.scale

        return String(
            format: "%@/%@ (%@; iOS %@; Scale/%0.2f)",
            bundleExecutable ?? bundleIdentifier ?? "",
            shortVersion ?? bundleVersion ?? "",
            phoneModel,
            systemVersion,
            scale
        )
    }
}
