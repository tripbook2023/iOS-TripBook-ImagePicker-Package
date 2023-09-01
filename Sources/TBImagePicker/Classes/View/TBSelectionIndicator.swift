//
//  TBSelectionIndicator.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import UIKit

private class NotHitView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if self == hitView { return nil }
        return hitView
    }
}

fileprivate final class IndicatorContentView: NotHitView {
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let checkImageView: UIImageView = {
        let view = UIImageView(image: .init(named: "check", in: .module, with: nil))
        view.tintColor = .white
        return view
    }()
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        configureUI(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(size: CGFloat) {
        backgroundColor = .clear
        switch TBPickerSettings.shared.selection {
        case .single:
            checkImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(checkImageView)
            NSLayoutConstraint.activate([
                checkImageView.widthAnchor.constraint(equalToConstant: size * 0.9),
                checkImageView.heightAnchor.constraint(equalToConstant: size * 0.9),
                checkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                checkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        case .multiple(_, _):
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
            numberLabel.font = .systemFont(ofSize: size * 0.5)
            addSubview(numberLabel)
            NSLayoutConstraint.activate([
                numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
                numberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                numberLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                numberLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
        }
    }
}

final class TBSelectionIndicator: UIButton {
    private let size: CGFloat
    
    private let circle: NotHitView = {
        let view = NotHitView()
        return view
    }()
    
    private lazy var contentView = IndicatorContentView(size: size)
    
    init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)
        configureUI()
        setNumber(nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(circle)
        let circleSize: CGFloat = size
        circle.layer.cornerRadius = circleSize / 2.0
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: circleSize),
            circle.heightAnchor.constraint(equalToConstant: circleSize)
        ])
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setNumber(_ number: Int?) {
        contentView.isHidden = (number == nil)
        circle.layer.borderWidth = 1
        circle.layer.borderColor = UIColor(r: 255, g: 255, b: 255).cgColor
        if let number = number {
            circle.backgroundColor = UIColor(r: 255, g: 78, b: 22)
            contentView.numberLabel.text = "\(number)"
        } else {
            circle.backgroundColor = UIColor(r: 255, g: 220, b: 219)
            contentView.numberLabel.text = ""
        }
    }
}
