//
//  ViewModel.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Combine

public protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func binding(input: Input) -> Output
}
