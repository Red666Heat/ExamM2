//
//  MainMapper.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import UIKit

enum MainMapper {
    static func map(state: MainState) -> MainView.Props {
        .init(
            image: state.currentImage,
            descriptionImage: state.imageDescription.isEmpty ? "Выберите изображение" : state.imageDescription,
            isLoading: state.isLoading,
            canCopy: state.canCopy,
            error: state.error,
            isShowStyle: !state.styles.isEmpty
        )
    }
}
