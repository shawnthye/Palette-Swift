//
//  MaterialPaletteTests.swift
//  MaterialPaletteTests
//
//  Created by Jonathan Zong on 10/30/15.
//  Copyright (c) 2015 Jonathan Zong. All rights reserved.
//

import UIKit
import XCTest
import Palette

class PaletteTests: XCTestCase {
    
//    var palette: Palette27?
    var logo: UIImage?
    
    
    override func setUp() {
        super.setUp()
        
        let a = CGRect(x: 0, y: 0, width: 100, height: 100)
        let b = CGRect(x: 0, y: 1, width: 100, height: 100)
        
        let boolean = b.intersects(a)
        
//        print("intersects: \(boolean): \(b.intersection(a))")
        
        logo = UIImage(named: "instagram_logo.jpg",
                                 in: Bundle(for: PaletteTests.self),
                                 compatibleWith: nil)
        
        
//        palette = Palette.init(logo!)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotNil() {
//        guard let swatches = palette?.swatches else {
//            XCTFail("failed to generate palette")
//            return
//        }
//        
//        XCTAssert(swatches.count > 0, "no swatch avaible")
    }
    
    func testPalette27(){
        guard let logo = logo?.cgImage else {
            return
        }
        
        let palette = Palette27.Builder(bitmap: logo)
//            .resizeBitmapArea(area: 300)
            .generate()
        let swatches = palette.swatches
        print("Total Color: \(swatches.count)")
        for swatch in swatches {
            print("Color: \(ColorInt.toHexString(swatch.rgb))")
        }
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
