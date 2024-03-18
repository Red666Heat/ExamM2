//
//  LaunchService.swift
//  
//
//  Created by Максим Зимин on 05.08.2023.
//

import Foundation
import UIKit

public final class LaunchService {
    private let router = LaunchRouter()

    public init() {
        launch()
    }
}

public extension LaunchService {
    func launch() {
        router.showMain()
    }
}
