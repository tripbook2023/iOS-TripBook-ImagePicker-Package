//
//  TBPhotosManager.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import Photos
import UIKit

final class TBPhotosManager {
    private var fetchResult: PHFetchResult<PHAsset>?
    let imageManager: PHCachingImageManager = .init()
    let photoLibrary: PHPhotoLibrary = .shared()
    private let settings: TBPickerSettings = .shared
    
    var onSelection: ((_ imageManager: TBAssetManager) -> Void)?
    var onDeSelction: ((_ imageManager: TBAssetManager) -> Void)?
    var onFinish: ((_ imageManagers: [TBAssetManager]) -> Void)?
    var onCancel: ((_ imageManagers: [TBAssetManager]) -> Void)?
    
    var selectedItems = [TBImageItem]() {
        didSet {
            selectedAction(selectedItems)
        }
    }
    
    var assetCount: Int? {
        fetchResult?.count
    }
    
    var selectedAction: ([TBImageItem]) -> Void = {_ in}
    
    var selectedImageManager: [TBAssetManager] {
        selectedItems.compactMap { $0.aseetManager }
    }
    
    var selectedItemCount: Int {
        selectedItems.count
    }
    
    var selectedItemIndexPaths: [IndexPath] {
        selectedItems.map {
            IndexPath(row: $0.index, section: 0)
        }
    }
    
    func getAsset(at: Int) -> PHAsset? {
        fetchResult?.object(at: at)
    }
    
    func getItem(id: String) -> TBImageItem? {
        return selectedItems.first {
            $0.assetID == id
        }
    }
    
    func getItemIndex(id: String) -> Int? {
        return selectedItems.firstIndex {
            $0.assetID == id
        }
    }
    
    func removeAllSelectItem() -> [IndexPath] {
        let indexPaths = selectedItems.map {  IndexPath(row: $0.index, section: 0) }
        selectedItems = []
        return indexPaths
    }
    
    func permissionCheck(_ collectionView: UICollectionView) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch photoAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(
                for: .readWrite
            ) { [weak self] status in
                switch status {
                case .authorized:
                    self?.requestCollection()
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                default:
                    break
                }
            }
        case .authorized, .limited:
            requestCollection()
            collectionView.reloadData()
        default:
            return
        }
    }
    
    func select(indexPath: IndexPath) {
        guard let asset = fetchResult?.object(at: indexPath.row) else { return }
        let item = TBImageItem(
            index: indexPath.row,
            assetID: asset.localIdentifier,
            aseetManager: .init(
                asset: asset,
                manager: imageManager,
                fetchOptions: settings.fetchOptions.options
            )
        )
        selectedItems.append(item)
        guard let itemManager = item.aseetManager else { return }
        onSelection?(itemManager)
    }
    
    func deSelect(indexPath: IndexPath) {
        if let positionIndex = selectedItems.firstIndex(where: {
            $0.assetID == fetchResult?.object(at: indexPath.row).localIdentifier
        }) {
            let removeItem = selectedItems.remove(at: positionIndex)
            guard let itemManager = removeItem.aseetManager else { return }
            onDeSelction?(itemManager)
        }
        return
    }
    
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection
            .fetchAssetCollections(
                with: .smartAlbum,
                subtype: .smartAlbumUserLibrary,
                options: nil
            )
        
        guard let cameraRollCollection = cameraRoll.firstObject else { return }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false
            )
        ]
        fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
}
