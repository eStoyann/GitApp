//
//  ExtensionUIViewController.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var content: UIViewController {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController ?? self
        }
        return self
    }
    func alert(title: String?, msg: String?, actions: [UIAlertAction]?, type: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: msg ,preferredStyle: type)
        alert.addActions(actions: actions != nil ? actions! : [] )
        present(alert, animated: true, completion: nil)
    }
}
