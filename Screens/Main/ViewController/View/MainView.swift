//
//  MainView.swift
//  
//
//  Created by Максим Зимин on 06.08.2023.
//

import Combine
import Then
import UIKit
import SnapKit

final class MainView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        let image: UIImage?
        let descriptionImage: String?
        let isLoading: Bool
        let canCopy: Bool
        let error: String?
        let isShowStyle: Bool
    }

    // MARK: - Publishers

    let viewPublisher = PassthroughSubject<MainViewModel.Input.Action, Never>()

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(saveImage))
        imageView.addGestureRecognizer(longPressGesture)
        return imageView
    }()

    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.text = Constants.inputImageDescription
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        let clearButton = UIBarButtonItem(
            title: "Очистить",
            style: .plain,
            target: self,
            action: #selector(clearButtonTapped)
        )
        let toolbar = UIToolbar()
        toolbar.setItems([
            clearButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton
        ], animated: false)
        toolbar.sizeToFit()
        
        // Установите панель инструментов в качестве inputAccessoryView для UITextView
        textView.inputAccessoryView = toolbar
        return textView
    }()

    private lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layerCornerRadius = 8
        view.isHidden = true
        return view
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideError))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        label.textColor = .black
        label.text = "Ошибка"
        return label
    }()

    private lazy var scroolView = UIScrollView()
    private lazy var scroolViewContainer = UIView()
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        return view
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 80
        return stackView
    }()

    private lazy var styleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Стиль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.textAlignment = .center
        button.addTarget(nil, action: #selector(styleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сгенерировать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.textAlignment = .center
        button.addTarget(nil, action: #selector(startButtonTap), for: .touchUpInside)
        button.contentEdgeInsets.left = 10
        button.contentEdgeInsets.right = 10
        return button
    }()

    private var scrollBotomConstraint: Constraint?

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        setup()
        setupBindings()
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension MainView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props
        setImage(image: props.image)
        activityIndicatorView.isHidden = !props.isLoading
        styleButton.isHidden = !props.isShowStyle
        if props.isLoading {
            activityIndicatorView.startAnimating()
            scroolView.isUserInteractionEnabled = false
        } else {
            activityIndicatorView.stopAnimating()
            scroolView.isUserInteractionEnabled = true
        }
        if let error = props.error {
            showError(error: error)
        } else {
            hideError()
        }
    }

}

// MARK: - Private Methods

private extension MainView {
    /// Настройка View
    func setup() {
        backgroundColor = .black
    }
    /// Настройка взаимодействия с дата слоем
    func setupBindings() {
        // Добавьте слушатель уведомлений
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
            if let self = self,
               let userInfo = notification.userInfo,
               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                let keyboardHeight = self.frame.height - keyboardFrame.origin.y
                if keyboardHeight > 0 {
                    self.scrollBotomConstraint?.update(inset: keyboardHeight + 5)
                } else {
                    self.scrollBotomConstraint?.update(inset: 30)
                }
            }
        }
    }

    /// Добавление Views
    func setupViews() {
        addSubview(scroolView)
        addSubview(errorView)
        addSubview(activityIndicatorView)
        errorView.addSubview(errorLabel)
        scroolView.addSubview(scroolViewContainer)
        scroolViewContainer.addSubview(mainImageView)
        scroolViewContainer.addSubview(inputTextView)
        buttonStackView.addArrangedSubviews([styleButton, startButton])
        scroolViewContainer.addSubview(buttonStackView)
    }

    /// Установка констреинтов
    func setupConstraints() {
        scroolView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(5)
            scrollBotomConstraint = $0.bottom.equalToSuperview().inset(30).constraint
            $0.left.right.equalToSuperview()
        }
        
        scroolViewContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }

        let imageHiegt = (UIScreen.main.bounds.width - 32) / 16 * 9
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(imageHiegt)
        }

        inputTextView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(inputTextView.snp.bottom).offset(15)
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }

        errorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(30)
        }

        errorLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.left.right.equalToSuperview().inset(12)
        }

        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func setImage(image: UIImage?) {
        mainImageView.image = image
    }
}

@objc
private extension MainView {
    func showError(error: String) {
        errorView.alpha = 1
        errorView.isHidden = false
        errorLabel.text = error
    }

    func hideError() {
        guard !errorView.isHidden else { return }
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.errorView.alpha = 0
            },
            completion: { [weak self] _ in
                self?.errorView.isHidden = true
            }
        )
    }

    func doneButtonTapped() {
        inputTextView.resignFirstResponder()
    }

    func clearButtonTapped() {
        inputTextView.text = ""
    }

    func styleButtonTap() {
        viewPublisher.send(.changeStyle)
    }

    func startButtonTap() {
        guard inputTextView.text != Constants.inputImageDescription else { return }
        doneButtonTapped()
        viewPublisher.send(.startGenerate(inputTextView.text ?? ""))
    }

    func saveImage() {
        viewPublisher.send(.savePhoto)
    }
}

// MARK: - UITextViewDelegate

extension MainView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        textView.text = Constants.inputImageDescription
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == Constants.inputImageDescription else { return }
        textView.text = ""
    }
}

// MARK: - Constants

private extension MainView {
    enum Constants {
        static let inputImageDescription = "Наижмите на текст и введите описание картинки"
    }
}
