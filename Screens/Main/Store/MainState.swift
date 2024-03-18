//
//  MainState.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import UIKit

struct MainState: Equatable {
    var currentImage: UIImage?
    var imageDescription: String = ""
    var isLoading: Bool = false
    var canCopy: Bool = false
    var error: String?
    var styles: [StyleModel] = []
    var currentStyle: StyleModel? = nil
}
