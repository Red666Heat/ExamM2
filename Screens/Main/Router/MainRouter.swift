//
//  MainRouter.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import UIKit

final class MainRouter: Router {
    enum Route {
        case close
        case choseStyle([StyleModel], StyleModel, (StyleModel) -> Void)
        case savePhotoAlert(() -> Void)
        case showAccessDeniedAlert
    }

    weak var viewController: UIViewController?

    func routeTo(_ route: Route) {
        switch route {
        case .close:
            self.viewController?.popOrDismiss()
            
        case let .choseStyle(styles, currentStyle, completion):
            let alertController = UIAlertController(title: "Выберите стиль", message: nil, preferredStyle: .alert)
            styles.forEach { style in
                var title = style.title
                if style == currentStyle { title += "(Выбран)" }
                alertController.addAction(UIAlertAction(
                    title: title,
                    style: .default,
                    handler: { _ in
                        completion(style)
                    }
                ))
            }

            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
            viewController?.present(alertController, animated: true, completion: nil)

        case .savePhotoAlert(let completion):
            let alertController = UIAlertController(title: "Сохранить картинку в галерею?", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(
                title: "Сохранить",
                style: .default,
                handler: { _ in
                    completion()
                }
            ))
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
            viewController?.present(alertController, animated: true, completion: nil)

        case .showAccessDeniedAlert:
            showAccessDeniedAlert()
        }
    }

    func showAccessDeniedAlert() {
        let alertController = UIAlertController(
            title: "Доступ к галерее запрещен",
            message: "Чтобы разрешить доступ к галерее, перейдите в настройки устройства и включите доступ для этого приложения.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        // Показываем алерт пользователю
        // Вам нужно вызвать этот метод в соответствующем месте вашего кода
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
