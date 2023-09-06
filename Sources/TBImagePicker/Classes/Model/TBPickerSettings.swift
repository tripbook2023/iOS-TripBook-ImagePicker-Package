//
//  TBPickerSettings.swift
//  
//
//  Created by 이시원 on 2023/08/28.
//

import Photos

public enum TBPickerSelection {
    case single
    case multiple(max: Int?, min: Int?)
}

public final class TBPickerFetchOptions {
  let options = PHImageRequestOptions()
  
  public var isSynchronous: Bool {
    get {
      return options.isSynchronous
    }
    set {
      options.isSynchronous = newValue
    }
  }
  
  public var deliveryMode: PHImageRequestOptionsDeliveryMode {
    get {
      return options.deliveryMode
    }
    set {
      options.deliveryMode = newValue
    }
  }
}

public final class TBPickerSettings {
    static let shared = TBPickerSettings()
    
    public let fetchOptions: TBPickerFetchOptions
    var selection: TBPickerSelection
    
    private init(
        fetchOptions: TBPickerFetchOptions = .init(),
        selection: TBPickerSelection = .single
    ) {
        self.fetchOptions = fetchOptions
        self.selection = selection
    }
}
