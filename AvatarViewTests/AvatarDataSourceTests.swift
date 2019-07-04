//
//  AvatarDataSourceTests.swift
//  AvatarDataSourceTests
//
//  Created by Paul Wood on 7/3/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
import Combine
@testable import AvatarView

class MockBeardService: BeardServiceType {
  
  init(injectedBeardMe: @escaping () -> AnyPublisher<UIImage, Never> ) {
    self.injectedBeardMe = injectedBeardMe
  }
  
  var injectedBeardMe: () -> AnyPublisher<UIImage, Never>
  
  func beardMe() -> AnyPublisher<UIImage, Never> {
    return injectedBeardMe()
  }

}

class AvatarDataSourceTests: XCTestCase {
  
  var sut: AvatarDataSource!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    sut = nil
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testPaulIsName() {
    //Given
    sut = AvatarDataSource()

    //When Then
    XCTAssertEqual(sut.viewModel.username, "Paul")
  }
  
  func testChangesAfterOnAppearIsCalled() {

    //Given
    sut = AvatarDataSource()
    sut.beardService = MockBeardService(injectedBeardMe: { () -> AnyPublisher<UIImage, Never> in
      return Just(UIImage(systemName: "circle")!)
        .eraseToAnyPublisher()
    })
    
    // When
    sut.onAppear()

    //Then
    XCTAssertNotNil(sut.viewModel.image, "Sets Image Name")
  }
  
  func testNoChangeNeeded() {
    
    //Given
    let expect = expectation(description: "Doesn't Change Image Until needed")
    sut = AvatarDataSource()
    sut.beardService = MockBeardService(injectedBeardMe: { () -> AnyPublisher<UIImage, Never> in
      return Just(UIImage(systemName: "circle")!)
        .delay(for: 50, scheduler:  self.sut.scheduler) //longer than the test
        .eraseToAnyPublisher()
    })
    
    
    //When We wait and fufill after the time should have passed
    sut.scheduler.schedule(after: DispatchQueue.SchedulerTimeType(.now() + 6)) {
      expect.fulfill()
    }
    
    //Then
    waitForExpectations(timeout: 7, handler: nil)
    XCTAssertNil(sut.viewModel.image, "Doesn't not sets image Name")
  }
  
  
}
