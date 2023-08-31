//
//  TBImagePickerView.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import UIKit

@available(iOS 13.0, *)
final class TBImagePickerView: UIView {
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
            okButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18),
            okButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
            okButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -54)
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
}
