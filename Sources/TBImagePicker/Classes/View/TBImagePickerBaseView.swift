//
//  TBImagePickerView.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import UIKit

final class TBImagePickerBaseView: UIView {
    private(set) lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        return collectionView
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.setTitle("사진 선택", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(.init(r: 76, g: 69, b: 67), for: .disabled)
        button.backgroundColor = .init(r: 225, g: 78, b: 22)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            photoCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        photoCollectionView.register(
            TBPickerCell.self,
            forCellWithReuseIdentifier: TBPickerCell.identifier
        )
        addSubview(okButton)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: self.photoCollectionView.bottomAnchor, constant: 14),
            okButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -58),
            okButton.widthAnchor.constraint(equalToConstant: 335),
            okButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }
    
    private var collectionViewLayout: UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1 / 3
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 1,
            bottom: 1,
            trailing: 1
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(fraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setOkButtonEndabled(_ v: Bool) {
        okButton.isEnabled = v
        okButton.backgroundColor = v ? .init(r: 225, g: 78, b: 22) : .init(r: 225, g: 220, b: 219)
    }
}
