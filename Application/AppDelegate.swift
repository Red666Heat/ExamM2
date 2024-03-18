//
//  AppDelegate.swift
//  Exam(Gordeev)
//
//  Created by Максим Зимин on 13.01.2024.
//

//
//  AppDelegate.swift
//  PoceDecs
//
//  Created by Максим Зимин on 05.08.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var launchService: LaunchService?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launchService = LaunchService()
        return true
    }
}
