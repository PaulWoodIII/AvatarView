//
//  BeardServiceTests.swift
//  AvatarViewTests
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
import Combine
import UIKit
@testable import AvatarView

class MockURLSession: DataTaskPublisherGettable {

  var urlSpy: [URL] = []
  var mockDataTaskPublisher: (_ url: URL) ->  AnyPublisher<(data: Data, response: URLResponse), URLError>
  
  init(mockDataTaskPublisher: @escaping (_ url: URL) ->  AnyPublisher<(data: Data, response: URLResponse), URLError> ) {
    self.mockDataTaskPublisher = mockDataTaskPublisher
  }
  
  func dataTaskAnyPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    urlSpy.append(url)
    return mockDataTaskPublisher(url)
  }
  
}

class BeardServiceTests: XCTestCase {
  
  var sut: BeardService!
  let testImage = Assets.Images.userPlaceHolder.uiImage
  let mockData: Data = Assets.Images.userPlaceHolder.uiImage.pngData()!
  let dispatchQueue: DispatchQueue = DispatchQueue.init(label: "BeardTests")
  
  override func tearDown() {
    sut = nil
  }
  
  func testMapsDataToImage() {
    
    // Given
    let expect = expectation(description: "Image is created from data")
    let mockURLSession = MockURLSession { (url) ->  AnyPublisher<(data: Data, response: URLResponse), URLError>  in
    
      let data: Data = self.mockData
      let res: URLResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: [:])!
      let emit = (data: data, response: res)
      return Just(emit).setFailureType(to: URLError.self ).eraseToAnyPublisher()
    }
    var spyImage: UIImage?
    sut = BeardService(urlSession: mockURLSession, scheduler: dispatchQueue)
    
    //When
    let cancelable = sut.beardMe().sink { (img) in
      spyImage = img
    }
    sut.scheduler.schedule(after: DispatchQueue.SchedulerTimeType(.now() + 0.1)) {
      expect.fulfill()
    }
    
    //Then
    waitForExpectations(timeout: 0.2, handler: nil)
    XCTAssertEqual(mockURLSession.urlSpy.count, 1, "one url request was made")
    XCTAssertEqual(mockURLSession.urlSpy.first?.absoluteString, "https://placebeard.it/640x360")
    XCTAssertNotNil(spyImage, "Image was created from the data")
    // I'd love to do this but just look up on the internet why image comparison is hard
    // XCTAssertEqual(spyImage?.pngData(), mockData)
  }
  
}
