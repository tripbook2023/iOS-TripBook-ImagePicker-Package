//
//  TBPickerCell.swift
//  
//
//  Created by 이시원 on 2023/08/29.
//

import UIKit

final class TBPickerCell: UICollectionViewCell {
    var representedAssetIdentifier: String!
    var indicatorButtonDidTap: () -> Void = {}
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(r: 225, g: 78, b: 22).cgColor
        return view
    }()
    
    let selectionIndicator = TBSelectionIndicator(size: 20)
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        selectionIndicator.addTarget(self, action: #selector(indicatorButtonAction), for: .touchUpInside)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        imageView.addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: imageView.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            borderView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            borderView.rightAnchor.constraint(equalTo: imageView.rightAnchor)
        ])
        
        addSubview(selectionIndicator)
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            selectionIndicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 20),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    private func indicatorButtonAction() {
        indicatorButtonDidTap()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        representedAssetIdentifier = nil
        indicatorButtonDidTap = {}
    }
}

