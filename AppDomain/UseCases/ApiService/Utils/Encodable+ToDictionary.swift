//
//  Encodable+ToDictionary.swift
//  Exam(Gordeev)
//
//  Created by Максим Зимин on 13.02.2024.
//

import Foundation

public extension Encodable {
    func toJSONData() -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }

    func toJSONString() -> String? {
        toJSONData()?.base64EncodedString()
    }

    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        let result = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String: Any]
        }

        return result ?? [:]
    }
}
