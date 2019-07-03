//
//  AvatarDataSource.swift
//  AvatarView
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol AvatarDataSourceType {
  var viewModel: AvatarViewModel { get }
  func onAppear()
}

class AvatarDataSource: AvatarDataSourceType, BindableObject {
  
  /// Expose the View Model as a struct to the View
  var viewModel: AvatarViewModel = AvatarViewModel(username: "Paul",
                                                   imageString: nil)
  
  /// Expose the Scheduler and its type for testing purposes
  var scheduler: DispatchQueue = DispatchQueue(label: "AvatarDataSource Queue")
  
  /// Hide the PassthroughSubject so nefarious objects don't call `.send()` on it
  /// really only this object should know to do that
  private var _didChange = PassthroughSubject<Void, Never>()
  
  /// Getter for the didChange Publisher to conform to `BindableObject`
  var didChange: AnyPublisher<Void, Never> {
    _didChange
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  /// below we are going to create a cancelable task with Combine, if the view disappears we might
  /// want to cancel this work, or if the work should be changed due to a user's input we'd want
  /// to cancel Just to think of two simple examples. For now we will cancel if the view appears for a second time
  private var imageCancelable: Cancellable?
  
  /// Handles the fact that the UI has appeared, nows time to do work
  func onAppear() {
    //do work
    imageCancelable?.cancel()
    imageCancelable = Just(1)
      .delay(for: 5.0, scheduler: scheduler)
      .sink { _ in
        self.viewModel.imageString = "circle.fill"
        self._didChange.send()
    }
  }
}


struct AvatarViewModel {
  /// I added this String to add flavor to the View Model instead of it being just an Image
  var username: String?
  
  /// Lets not actually deal with UIImage that isn't what I want to teach here, instead lets make the
  /// system image dynamic with Combine to simulate networking delay and focus on how to make
  /// something dynamic
  var imageString: String?
}
