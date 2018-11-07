//
//  MaterialPaletteTests.swift
//  MaterialPaletteTests
//
//  Created by Jonathan Zong on 10/30/15.
//  Copyright (c) 2015 Jonathan Zong. All rights reserved.
//

import UIKit
import XCTest
import MaterialPalette

class MaterialPaletteTests: XCTestCase {
    
    var palette: Palette?
    override func setUp() {
        super.setUp()
        
        for i in stride(from: 84, to: 83, by: 1){
            print(i)
        }
        guard let logo = UIImage(named: "instagram_logo.jpg",
                                 in: Bundle(for: MaterialPaletteTests.self),
                                 compatibleWith: nil) else {
                                    XCTFail("instragram logo not found")
                                    return
        }
        palette = Palette.init(logo)
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotNil() {
        guard let swatches = palette?.swatches else {
            XCTFail("failed to generate palette")
            return
        }
        
        XCTAssert(swatches.count > 0, "no swatch avaible")
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
