import Foundation
import Moya
import UIKit

public protocol NetworkEndpoints: TargetType, AccessTokenAuthorizable {}

public extension NetworkEndpoints {
    var baseURL: URL {
        Preferences.Server.serverBaseUrl
    }

    var headers: [String: String]? {
        [
            "X-Key": "Key CE5EFD9FC09C0CCFDC8D647D30F5E110",
            "X-Secret": "Secret 68B7F48EB6D97FD73127C529BA8328C1",
//            "X-Device-Id": UIDevice.current.identifierForVendor?.uuidString ?? "",
//            "X-Device-App": Bundle.main.bundleIdentifier ?? ""
        ]
    }
}
