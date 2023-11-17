import UIKit
import SwiftUI
 
public final class TBImagePicker: UINavigationController {
    var setting = TBPickerSettings.shared
    
    public init(
        _ selection: TBPickerSelection,
        onSelection: ((_ imageManager: TBAssetManager) -> Void)?,
        onDeSelction: ((_ imageManager: TBAssetManager) -> Void)?,
        onFinish: ((_ imageManagers: [TBAssetManager]) -> Void)?,
        onCancel: ((_ imageManagers: [TBAssetManager]) -> Void)?
    ) {
        self.setting.selection = selection
        let vc = TBPickerViewController()
        vc.photosManager.onSelection = onSelection
        vc.photosManager.onDeSelction = onDeSelction
        vc.photosManager.onFinish = onFinish
        vc.photosManager.onCancel = onCancel
        super.init(rootViewController: vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public struct TBImagePickerView: UIViewControllerRepresentable {
    var onSelection: ((_ imageManager: TBAssetManager) -> Void)?
    var onDeSelction: ((_ imageManager: TBAssetManager) -> Void)?
    var onFinish: ((_ imageManagers: [TBAssetManager]) -> Void)?
    var onCancel: ((_ imageManagers: [TBAssetManager]) -> Void)?
    var selection: TBPickerSelection
    
    public init(
        _ selection: TBPickerSelection,
        onSelection: ((_: TBAssetManager) -> Void)? = nil,
        onDeSelction: ((_: TBAssetManager) -> Void)? = nil,
        onFinish: ((_: [TBAssetManager]) -> Void)? = nil,
        onCancel: ((_: [TBAssetManager]) -> Void)? = nil
    ) {
        self.selection = selection
        self.onSelection = onSelection
        self.onDeSelction = onDeSelction
        self.onFinish = onFinish
        self.onCancel = onCancel
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        TBImagePicker(
            selection,
            onSelection: onSelection,
            onDeSelction: onDeSelction,
            onFinish: onFinish,
            onCancel: onCancel
        )
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
