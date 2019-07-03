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
    let expect = expectation(description: "Sets Image Name")
    sut = AvatarDataSource()
    sut.onAppear()
    
    //When We wait and fufill after the time should have passed
    sut.scheduler.schedule(after: DispatchQueue.SchedulerTimeType(.now() + 6)) {
      expect.fulfill()
    }
    
    //Then
    waitForExpectations(timeout: 7, handler: nil)
    XCTAssertNotNil(sut.viewModel.imageString, "Sets Image Name")
  }
  
  func testNoChangeNeeded() {
    
    //Given
    let expect = expectation(description: "Doesn't Change Image Until needed")
    sut = AvatarDataSource()
    
    //When We wait and fufill after the time should have passed
    sut.scheduler.schedule(after: DispatchQueue.SchedulerTimeType(.now() + 6)) {
      expect.fulfill()
    }
    
    //Then
    waitForExpectations(timeout: 7, handler: nil)
    XCTAssertNil(sut.viewModel.imageString, "Doesn't not sets image Name")
  }
  
  
}
