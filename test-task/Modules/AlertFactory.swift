//
//  AlertFactory.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

enum ErrorAlertType: String {
    case cameraAccess = "Разрешите приложению доступ к камере в настройках приложения"
    case qrReaderError = "Ошибка чтения QR, попробуйте позже"
    
    var alertController: UIAlertController {
        let message = self.rawValue
        let alertViewController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        return alertViewController
    }
}
