//
//  MaterialPaletteTests.swift
//  MaterialPaletteTests
//
//  Created by Jonathan Zong on 10/30/15.
//  Copyright (c) 2015 Jonathan Zong. All rights reserved.
//

import UIKit
import XCTest

@testable import Palette

class ColorUtilsTests: XCTestCase {
    
    func testColorToHSL() {
        let color565 = 0xFF000061
        var tempHsl = [Float](repeating: 0, count: 3)
        ColorUtils27.colorToHSL(color: 0x00000061, outHsl: &tempHsl)
//        tempHsl.reserveCapacity(3)
//        let rgb = ColorCutQuantizer27.approximateToRgb888(r: ColorCutQuantizer27.quantizedRed(color565),
//                                                         g: ColorCutQuantizer27.quantizedGreen(color565),
//                                                         b: ColorCutQuantizer27.quantizedBlue(color565))
//        ColorUtils27.colorToHSL(color: rgb, outHsl: &tempHsl);
////        ColorUtils27
//        let shouldIgnoreColor = !Palette27.defaultFilter.isAllowed(rgb, tempHsl)
//        XCTAssert(false)
//        ColorUtils27
        //        guard let swatches = palette?.swatches else {
        //            XCTFail("failed to generate palette")
        //            return
        //        }
        //
        //        XCTAssert(swatches.count > 0, "no swatch avaible")
    }
    
}
