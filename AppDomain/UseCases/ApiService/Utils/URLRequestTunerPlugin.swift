import Foundation
import Moya

internal final class URLRequestTunerPlugin: PluginType {
    // MARK: - Constants

    private struct DefaultValues {
        static let timeOutInterval: TimeInterval = 30
    }

    // MARK: - PluginType protocol

    internal func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutableRequest = request
        mutableRequest.timeoutInterval = timeOut(for: target)
        return mutableRequest
    }

    // MARK: - Private Functions

    private func timeOut(for target: TargetType) -> TimeInterval {
        switch target {
        default:
            return DefaultValues.timeOutInterval
        }
    }
}
