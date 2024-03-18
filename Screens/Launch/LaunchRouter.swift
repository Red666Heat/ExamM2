//
//  LaunchRouter.swift
//  
//
//  Created by Максим Зимин on 05.08.2023.
//

import Foundation
import SwifterSwift
import UIKit

final class LaunchRouter {
    private let window: UIWindow

    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.makeKeyAndVisible()
    }

    func showMain() {
        let viewController = MainViewController()
        window.rootViewController = viewController
    }
}
