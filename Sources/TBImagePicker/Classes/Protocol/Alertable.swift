//
//  Alertable.swift
//  
//
//  Created by 이시원 on 2023/09/01.
//

import UIKit

protocol Alertable {}

extension Alertable {
  func makeAlert(message: String) -> UIAlertController {
    let alert = UIAlertController(
      title: nil,
      message: message,
      preferredStyle: .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    return alert
  }
}
