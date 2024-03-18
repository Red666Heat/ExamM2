//
//  File.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Foundation
import UIKit

public class NavigationController: UINavigationController {
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override public init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavigationItems(rootViewController)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }

    // MARK: - Overrides

    override public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        super.pushViewController(viewController, animated: animated)
        setupNavigationItems(viewController)
    }

    override public func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        viewControllers.forEach { setupNavigationItems($0) }
    }
}

// MARK: - Private Methods

private extension NavigationController {
    func setupNavigationItems(_ viewController: UIViewController) {
        viewController.navigationItem.backButtonTitle = ""
    }
}
