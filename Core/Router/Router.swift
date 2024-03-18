//
//  File.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Foundation
import UIKit

public protocol Router: AnyObject {
    var viewController: UIViewController? { get }
}

public extension Router {
    func push(viewController: UIViewController) {
        self.viewController?.navigationController?
            .pushViewController(viewController, animated: true)
    }

    func present(viewController: UIViewController) {
        self.viewController?.present(viewController, animated: true, completion: nil)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        self.viewController?.dismiss(animated: animated, completion: completion)
    }

    func pop() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }

    func popOrDismiss() {
        self.viewController?.popOrDismiss()
    }
}
