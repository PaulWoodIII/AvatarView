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

/// You need to use a Reference Type for things that deal with data. This is because anything dealing with data needs to persist
/// through the lifetime of all the closures nearly every data object is going to be dealing with. You'll be capturing self and structs
/// simply cannot do that. Structs are great to define what data is, but not for to encapsulate mutating state
class AvatarDataSource: AvatarDataSourceType, BindableObject {
  
  /// Expose the View Model as a struct to the View
  var viewModel: AvatarViewModel = AvatarViewModel(username: "Paul",
                                                   image: nil)
  
  /// A service that does some networking its Interface defines a function that returns a
  /// Publisher, In Test use injection to change the default to some other mock object
  var beardService: BeardServiceType = BeardService()
  
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
    imageCancelable?.cancel()
    imageCancelable = beardService.beardMe()
      .sink { img in
        self.viewModel.image = img
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
  var image: UIImage?
}
