//
//  BeardService.swift
//  AvatarView
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol BeardServiceType {
  func beardMe() -> AnyPublisher<UIImage, Never>
}

protocol DataTaskPublisherGettable {
  func dataTaskAnyPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: DataTaskPublisherGettable {
  func dataTaskAnyPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    return self.dataTaskPublisher(for: url).eraseToAnyPublisher()
  }
}

class BeardService: BeardServiceType {
  
  /// injectable
  var urlSession: DataTaskPublisherGettable
  
  /// injectable
  var scheduler: DispatchQueue
  
  init(urlSession: DataTaskPublisherGettable = URLSession.shared,
    scheduler: DispatchQueue = DispatchQueue(label: "BeardService")){
    self.urlSession = urlSession
    self.scheduler = scheduler
  }
  
  func beardMe() -> AnyPublisher<UIImage, Never> {
    let url = URL(string: "https://placebeard.it/640x360")!
    return urlSession
      .dataTaskAnyPublisher(for: url)
      .receive(on: scheduler)
      .map { (data, response) -> UIImage? in
        guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200,
          let img = UIImage(data: data) else {
            return nil
        }
        return img
    }.replaceNil(with: Assets.Images.beardPlaceHolder.uiImage)
      .replaceError(with: Assets.Images.beardPlaceHolder.uiImage)
      .eraseToAnyPublisher()
  }
}
