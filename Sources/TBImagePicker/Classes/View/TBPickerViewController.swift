//
//  TBPickerViewController.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import Photos
import UIKit
import Foundation

final class TBPickerViewController: UIViewController, Alertable {
    let photosManager = TBPhotosManager()
    private let mainView = TBImagePickerBaseView()
    public let settings = TBPickerSettings.shared
    private let beforeButton = UIButton()
    private let options = PHImageRequestOptions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        photosManager.selectedAction = { [weak self] items in
            guard let self = self else { return }
            self.mainView.setOkButtonEndabled(self.checkOkButtonEndabled(items: items))
        }
        beforeButton.addTarget(self, action: #selector(beforeButtomDidTap), for: .touchUpInside)
        mainView.photoCollectionView.dataSource = self
        mainView.okButton.addTarget(self, action: #selector(okButtomDidTap), for: .touchUpInside)
        photosManager.photoLibrary.register(self)
        options.isNetworkAccessAllowed = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photosManager.permissionCheck(mainView.photoCollectionView)
    }
    
    @objc
    private func okButtomDidTap() {
        let assetManagers = photosManager.selectedImageManager
        photosManager.onFinish?(assetManagers)
        dismiss(animated: true)
    }
    
    private func checkOkButtonEndabled(items: [TBImageItem]) -> Bool {
        switch settings.selection {
        case .single:
            return items.count >= 1
        case .multiple(_, let min):
            if let min = min {
                return items.count >= min
            } else {
                return true
            }
        }
    }
        
    @objc
    private func beforeButtomDidTap() {
        let assetManagers = photosManager.selectedImageManager
        photosManager.onCancel?(assetManagers)
        dismiss(animated: true)
    }
}

// MARK: - UI

extension TBPickerViewController {
    private func configureUI() {
        title = "이미지 선택"
        
        view.backgroundColor = .systemBackground
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.setOkButtonEndabled(self.checkOkButtonEndabled(items: photosManager.selectedItems))
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
        beforeButton.setImage(.init(named: "before", in: .module, with: nil), for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: beforeButton)
        beforeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            beforeButton.widthAnchor.constraint(equalToConstant: 24),
            beforeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        beforeButton.contentVerticalAlignment = .fill
        beforeButton.contentHorizontalAlignment = .fill
    }
}

extension TBPickerViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photosManager.assetCount ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = mainView.photoCollectionView.dequeueReusableCell(
            withReuseIdentifier: TBPickerCell.identifier,
            for: indexPath
        ) as? TBPickerCell ?? TBPickerCell()
        
        guard let asset = photosManager.getAsset(at: indexPath.row) else { return cell }
        cell.representedAssetIdentifier = asset.localIdentifier
        let item = self.photosManager.getItem(id: asset.localIdentifier)
        cell.indicatorButtonDidTap = { [weak self] in
            guard let self = self else { return }
            if item != nil {
                self.deSelect(indexPath: indexPath)
            } else {
                self.select(indexPath: indexPath)
            }
        }
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        photosManager.imageManager.requestImage(
            for: asset,
            targetSize: cell.bounds.size,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        }
        
        if let index = photosManager.getItemIndex(id: asset.localIdentifier) {
            cell.selectionIndicator.setNumber(index + 1)
            cell.borderView.isHidden = false
        } else {
            cell.selectionIndicator.setNumber(nil)
            cell.borderView.isHidden = true
        }
        
        return cell
    }
}

extension TBPickerViewController {
    private func deSelect(indexPath: IndexPath) {
        photosManager.deSelect(indexPath: indexPath)
        mainView.photoCollectionView.reloadItems(at: photosManager.selectedItemIndexPaths + [indexPath])
    }
    
    private func select(indexPath: IndexPath) {
        switch settings.selection {
        case .single:
            let indexPaths = photosManager.removeAllSelectItem()
            photosManager.select(indexPath: indexPath)
            mainView.photoCollectionView.reloadItems(at: [indexPath] + indexPaths)
        case .multiple(max: let max, _):
            if let selectionLimit = max {
                if selectionLimit > photosManager.selectedItemCount {
                    photosManager.select(indexPath: indexPath)
                } else {
                    let message = "이미지는 최대 \(selectionLimit)장까지 첨부할 수 있습니다."
                    let alert = makeAlert(message: message)
                    present(alert, animated: true)
                }
            } else {
                photosManager.select(indexPath: indexPath)
            }
            mainView.photoCollectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver

extension TBPickerViewController: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        photosManager.requestCollection()
        DispatchQueue.main.async {
            self.mainView.photoCollectionView.reloadData()
        }
    }
}

