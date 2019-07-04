//
//  AvatarView.swift
//  AvatarView
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI

struct AvatarView : View {
  
  @EnvironmentObject var viewModelProvider: AvatarDataSource
  
  var body: some View {
    
    VStack {
      Text( viewModelProvider.viewModel.username ?? "Unknown User")
      Image(uiImage: viewModelProvider.viewModel.image ?? Assets.Images.userPlaceHolder.uiImage)
    }
    .onAppear {
      self.viewModelProvider.onAppear()
    }
  }
}

#if DEBUG
struct AvatarView_Previews : PreviewProvider {
  static var previews: some View {
    AvatarView().modifier(iPhoneEnvironment())
  }
}
#endif
