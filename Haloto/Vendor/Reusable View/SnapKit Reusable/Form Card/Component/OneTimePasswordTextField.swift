//
//  OneTimePasswordTextField.swift
//  Haloto
//
//  Created by Javier Fransiscus on 06/11/21.
//

import SnapKit
import UIKit

class OneTimePasswordTextField: UITextField {
    var didEnterLastDigit: ((String) -> Void)?

    private var isConfigured = false
    private var digitLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()

    func configure(with slotCount: Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()

        configureTextField()

        let labelsStackView = createLablesStackView(with: slotCount)
        addSubview(labelsStackView)

        addGestureRecognizer(tapRecognizer)

        labelsStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

private extension OneTimePasswordTextField {
    func configureTextField() {
        tintColor = .clear
        textColor = .clear
        backgroundColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }

    func createLablesStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 13

        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Bold", size: 18)
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.layer.borderWidth = 3
            label.cornerRadius = 5
        

            label.isUserInteractionEnabled = true

            stackView.addArrangedSubview(label)
            label.snp.makeConstraints { make in
                make.width.equalTo(40)
            }

            digitLabels.append(label)
        }

        return stackView
    }

    @objc
    func textDidChange() {
        guard let text = text, text.count <= digitLabels.count else { return }

        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]

            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }

        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }
}

extension OneTimePasswordTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
