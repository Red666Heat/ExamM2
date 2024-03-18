//
//  MainViewController.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Combine
import UIKit

public final class MainViewController: UIViewController {
    // MARK: - Private Props

    private lazy var moduleView = MainView()
    private let viewModel: MainViewModel
    private let router = MainRouter()

    // MARK: - Internal Props

    private(set) var store: Set<AnyCancellable> = []

    // MARK: - Publishers

    private let conrollerPublisher = PassthroughSubject<MainViewModel.Input.Action, Never>()
    
    // MARK: - LifeCycle

    public required init() {
        self.viewModel = MainViewModel()
        super.init(nibName: nil, bundle: nil)
        self.router.viewController = self
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        view = moduleView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        binding()
        conrollerPublisher.send(.viewDidLoad)
    }
}

// MARK: - Private Methods

private extension MainViewController {
    func binding() {
        let inputPulisher = Publishers.MergeMany([
            moduleView.viewPublisher.eraseToAnyPublisher(),
            conrollerPublisher.eraseToAnyPublisher()
        ])
        let output = viewModel.binding(
            input: .init(
                inputPublisher: inputPulisher.eraseToAnyPublisher()
            )
        )
        
        output.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.moduleView.render(MainMapper.map(state: state))
            }
            .store(in: &store)
        
        output.routePublisher
            .receive(on: DispatchQueue.main) 
            .sink { [weak self] route in
                self?.router.routeTo(route)
            }
            .store(in: &store)
    }
}
