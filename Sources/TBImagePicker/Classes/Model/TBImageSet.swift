//
//  TBImageSet.swift
//  
//
//  Created by 이시원 on 2023/09/07.
//

import UIKit

public class TBImageSet: Hashable {
    public var image: UIImage
    public var imageID: UUID
    
    public static func == (lhs: TBImageSet, rhs: TBImageSet) -> Bool {
        lhs.imageID == rhs.imageID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(imageID)
    }
    
    public init(image: UIImage, imageID: UUID) {
        self.image = image
        self.imageID = imageID
    }
   
}
