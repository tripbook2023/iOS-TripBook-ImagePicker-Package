//
//  TBImageItem.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import Foundation

final class TBImageItem {
    let index: Int
    let assetID: String
    let aseetManager: TBAssetManager?
    
    init(
        index: Int,
        assetID: String,
        aseetManager: TBAssetManager?
    ) {
        self.index = index
        self.assetID = assetID
        self.aseetManager = aseetManager
    }
}
