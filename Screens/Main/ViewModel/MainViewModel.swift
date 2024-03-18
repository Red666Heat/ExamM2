//
//  MainViewModel.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Combine
import Foundation
import UIKit
import Vision
import VisionKit
import Photos

final class MainViewModel: NSObject {
    // MARK: - Dependencies

    private let apiService = UseCaseFactory.instance.makeApiService().catalogService

    // MARK: - Internal Props

    private(set) var store: Set<AnyCancellable> = []

    // MARK: - Publishers

    private let statePublisher = PassthroughSubject<MainState, Never>()
    private let routePublisher = PassthroughSubject<MainRouter.Route, Never>()

    // MARK: - Private Props

    private var state = MainState() {
        didSet {
            guard state != oldValue else { return }
            statePublisher.send(state)
        }
    }

    // MARK: - LifeCycle

    override init() {
        super.init()
    }
}

// MARK: - ViewModel

extension MainViewModel: ViewModel {
    struct Input {
        enum Action: Equatable {
            case viewDidLoad
            case close
            case startGenerate(String)
            case changeStyle
            case savePhoto
        }
        
        let inputPublisher: AnyPublisher<Action, Never>
    }

    struct Output {
        let statePublisher: AnyPublisher<MainState, Never>
        let routePublisher: AnyPublisher<MainRouter.Route, Never>
    }

    func binding(input: Input) -> Output {
        input.inputPublisher
            .sink { [weak self] action in
                self?.reduce(action: action)
            }
            .store(in: &store)
        
        return .init(
            statePublisher: statePublisher.eraseToAnyPublisher(),
            routePublisher: routePublisher.eraseToAnyPublisher()
        )
    }
}

// MARK: - Private Methods

private extension MainViewModel {
    func reduce(action: Input.Action) {
        switch action {
        case .viewDidLoad:
            statePublisher.send(state)
            getStyles()

        case .close:
            routePublisher.send(.close)
            
        case .startGenerate(let text):
            state.imageDescription = text
            startGenerate()

        case .changeStyle:
            guard let currentStyle = state.currentStyle else { break }
            routePublisher.send(
                .choseStyle(state.styles, currentStyle) { [weak self] style in
                    self?.state.currentStyle = style
                }
            )

        case .savePhoto:
            guard let image = state.currentImage else { break }
            routePublisher.send(.savePhotoAlert { [weak self] in
                self?.writeToPhotoAlbum(image: image)
            })
        }
    }
}

private extension MainViewModel {
    func startGenerate() {
        guard !state.imageDescription.isEmpty else { return }
        state.isLoading = true
        generateImage()
    }

    func generateImage() {
        let parameters: GenImageParameters = GenImageParameters(
            style: state.currentStyle?.name ?? "DEFAULT",
            width: 1024,
            height: 576,
            numImages: 1,
            negativePromptUnclip: nil,
            generateParams: .init(
                query: state.imageDescription
            )
        )
        apiService.generateImage(parameters: parameters) { [weak self] response in
            switch response {
            case .success(let result):
                self?.checkGenerateImage(uuid: result.uuid)
                
            case .failure(let error):
                self?.setError(error: error.localizedDescription)
                self?.state.isLoading = false
                print(error)
            }
        }
    }

    func getGenerateModels() {
        apiService.getGenerateModels { _ in
        }
    }

    func checkGenerateImage(uuid: String) {
        apiService.checkGenerateImage(uuid: uuid) { [weak self] response in
            switch response {
            case .success(let result):
                print("===================\(result.status)")
                switch result.status {
                case "DONE":
                    guard
                        let imageStr = result.images?.first,
                        let data = Data(base64Encoded: imageStr),
                        let image = UIImage(data: data)
                    else {
                        self?.setError()
                        return
                    }
                    self?.state.error = nil
                    self?.state.currentImage = image
                    self?.state.isLoading = false
                    
                case "FAIL":
                    DispatchQueue.main.async {
                        self?.setError(error: result.errorDescription ?? "Ошибка")
                    }
                    
                default:
                    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
                        self?.checkGenerateImage(uuid: uuid)
                    }
                }
                
            case .failure(let error):
                self?.setError(error: error.localizedDescription)
                print(error)
            }
        }
    }

    func setError(error: String = "Ошибка") {
        state.error = error
        state.isLoading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
            self?.state.error = nil
        }
    }

    func getStyles() {
        state.isLoading = true
        apiService.getStyles { [weak self] response in
            switch response {
            case .success(let result):
                self?.state.styles = result
                if !result.isEmpty {
                    self?.state.currentStyle = result.first(where: { $0.name == "DEFAULT" })
                }
                self?.state.isLoading = false
                
            case .failure(let error):
                self?.state.isLoading = false
                print(error)
            }
        }
    }

    func writeToPhotoAlbum(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                self.state.isLoading = true
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
            case .denied, .restricted:
                self.routePublisher.send(.showAccessDeniedAlert)
            default:
                break
            }
        }
    }

    @objc 
    func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        state.isLoading = false
    }
}
