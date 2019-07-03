//
//  Environments.swift
//  AvatarView
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI

/// Helpers to setup Environment Objects for different platforms
struct iPhoneEnvironmentObject {
  static let shared = iPhoneEnvironmentObject()
  let avatarDataSource = AvatarDataSource()
}

/// Many Views in a production app will need the same Environment Objects added to them
/// this is a helper Modifier that reduces that setup code in the `PreviewProvider`
struct iPhoneEnvironment: ViewModifier {
  func body(content: Content) -> some View {
    return content
      .environmentObject(iPhoneEnvironmentObject.shared.avatarDataSource)
  }
}
