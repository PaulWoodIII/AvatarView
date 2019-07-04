//
//  Assets+Images.swift
//  AvatarView
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import UIKit

extension Assets {
  enum Images: String {
    case userPlaceHolder = "UserPlaceholder"
    case beardPlaceHolder = "BeardPlaceholder"
    
    var uiImage : UIImage {
      return UIImage(named: self.rawValue)!
    }
  }
}
