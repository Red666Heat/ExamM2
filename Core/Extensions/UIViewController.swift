//
//  File.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Foundation
import SnapKit
import SwifterSwift
import UIKit

public extension UIViewController {
    var isRoot: Bool {
        let rootVc = navigationController?.viewControllers.first
        return rootVc == nil || rootVc == self
    }
    
    func popOrDismiss() {
        if isRoot {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController()
        }
    }
    
    var topGuide: SnapKit.ConstraintItem {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.snp.top
        } else {
            return topLayoutGuide.snp.bottom
        }
    }
    
    var leftGuide: SnapKit.ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.left
        } else {
            return view.snp.left
        }
    }
    
    var rightGuide: SnapKit.ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.right
        } else {
            return view.snp.right
        }
    }
    
    var bottomGuide: SnapKit.ConstraintItem {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.snp.bottom
        } else {
            return bottomLayoutGuide.snp.top
        }
    }
}
