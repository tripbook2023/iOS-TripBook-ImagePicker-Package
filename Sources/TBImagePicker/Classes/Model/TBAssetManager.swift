//
//  TBAssetManager.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import Photos
import UIKit

public final class TBAssetManager {
    private let asset: PHAsset
    public let id: UUID
    private let manager: PHCachingImageManager
    private let fetchOptions: PHImageRequestOptions?
    
    init(
        asset: PHAsset,
        id: UUID = UUID(),
        manager: PHCachingImageManager,
        fetchOptions: PHImageRequestOptions?
    ) {
        self.asset = asset
        self.id = id
        self.manager = manager
        self.fetchOptions = fetchOptions
    }
    
    public func request(
        size: CGSize,
        completion: @escaping (UIImage?, [AnyHashable : Any]?) -> Void
    ) {
        manager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: fetchOptions,
            resultHandler: completion)
    }
}
