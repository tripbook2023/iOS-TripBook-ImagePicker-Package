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

final class TBSelectionIndicator: UIButton {
    private let circle: NotHitView = {
        let view = NotHitView()
        return view
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        configureUI(size: size)
        setNumber(nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(size: CGFloat) {
        addSubview(circle)
        addSubview(numberLabel)
        let circleSize: CGFloat = size
        circle.layer.cornerRadius = circleSize / 2.0
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: circleSize),
            circle.heightAnchor.constraint(equalToConstant: circleSize)
        ])
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = .systemFont(ofSize: size * 0.5)
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setNumber(_ number: Int?) {
        numberLabel.isHidden = (number == nil)
        circle.layer.borderWidth = 1
        circle.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        if let number = number {
            circle.backgroundColor = UIColor(red: 255, green: 78, blue: 22, alpha: 1)
            numberLabel.textColor = .white
            numberLabel.text = "\(number)"
        } else {
            circle.backgroundColor = UIColor(red: 225, green: 220, blue: 219, alpha: 1)
            numberLabel.text = ""
        }
    }
}
