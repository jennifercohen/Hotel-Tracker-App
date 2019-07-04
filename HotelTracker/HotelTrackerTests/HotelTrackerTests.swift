//
//  HotelTrackerTests.swift
//  HotelTrackerTests
//
//  Created by Jennifer Cohen on 21/06/2019.
//  Copyright © 2019 Jennifer Cohen. All rights reserved.
//

import XCTest
@testable import HotelTracker

class HotelTrackerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    //MARK: Hotel Class Tests
    
    //Confirm that hotel initialiser returns hotel object when passed valid parameters
    func testHotelInitalisationSucceeds() {
        //Zero rating
        let zeroRatingHotel = Hotel.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingHotel)
        
        //Highest positive rating
        let positiveRatingHotel = Hotel.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingHotel)
    }
        
        //Confirm that the Hotel initialiser returns nil when passed a negative rating or an empty name
        func testHotelInitialisationFails() {
            
            //Negative rating
            let negativeRatingHotel = Hotel.init(name: "Negative", photo: nil, rating: -1)
            XCTAssertNil(negativeRatingHotel)
            
            //Rating exceeds maximum
            let largeRatingHotel = Hotel.init(name: "Large", photo: nil, rating: 6)
            XCTAssertNil(largeRatingHotel)
            
            //Empty String
            let emptyStringHotel = Hotel.init(name: "", photo: nil, rating: 0)
            XCTAssertNil(emptyStringHotel)
        }
    }

