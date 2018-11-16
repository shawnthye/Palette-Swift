//
//  Palette27.swift
//  Palette
//
//  Created by Shawn Thye on 12/11/2018.
//  Copyright © 2018 Jonathan Zong. All rights reserved.
//

import Foundation

public final class Palette27 {
    
    public typealias Filter = PaletteFilter
    
    static let defaultResizeBitmapArea = 112 * 112
    static let defaultCalculateNumberColors = 16
    
    static let minContrastTitleText: Float = 3.0
    static let minContrastBodyText: Float = 4.5
    
    public let swatches: [Swatch]
    public let targets: [Target]
    
    private let mSelectedSwatches: [Target : Swatch]
    private let mUsedColors: [ColorInt: Bool]
    
    private var dominantSwatch: Swatch?
    
    init(swatches: [Swatch], targets: [Target]) {
        self.swatches = swatches
        self.targets = targets
        
        mUsedColors = [:]
        mSelectedSwatches = [:]
        
        dominantSwatch = findDominantSwatch()
    }
    
    /**
     * Returns the most vibrant swatch in the palette. Might be null.
     *
     * @see Target#VIBRANT
     */
    public var vibrantSwatch: Swatch? {
        get { return getSwatchForTarget(Target.VIBRANT) }
    }
    
    /**
     * Returns a light and vibrant swatch from the palette. Might be null.
     *
     * @see Target#LIGHT_VIBRANT
     */
    public var lightVibrantSwatch: Swatch? {
        get { return getSwatchForTarget(Target.LIGHT_VIBRANT) }
    }
    
    /**
     * Returns a dark and vibrant swatch from the palette. Might be null.
     *
     * @see Target#DARK_VIBRANT
     */
    public var darkVibrantSwatch: Swatch? {
        get { return getSwatchForTarget(Target.DARK_VIBRANT) }
    }
    
    /**
     * Returns a muted swatch from the palette. Might be null.
     *
     * @see Target#MUTED
     */
    public var mutedSwatch: Swatch? {
        get { return getSwatchForTarget(Target.MUTED) }
    }
    
    /**
     * Returns a muted and light swatch from the palette. Might be null.
     *
     * @see Target#LIGHT_MUTED
     */
    public var lightMutedSwatch: Swatch? {
        get { return getSwatchForTarget(Target.LIGHT_MUTED) }
    }
    
    /**
     * Returns a muted and dark swatch from the palette. Might be null.
     *
     * @see Target#DARK_MUTED
     */
    public var darkMutedSwatch: Swatch? {
        get { return getSwatchForTarget(Target.DARK_MUTED) }
    }
    
    /**
     * Returns the selected swatch for the given target from the palette, or {@code null} if one
     * could not be found.
     */
    public func getSwatchForTarget(_ target: Target) -> Swatch? {
        return mSelectedSwatches[target]
    }
    
    private func findDominantSwatch() -> Swatch? {
        var maxSwatch: Swatch?
        for swatch in swatches {
            if swatch.population > maxSwatch?.population ?? Int.min {
                maxSwatch = swatch
            }
        }
        return maxSwatch
    }
}

extension Palette27 {
    
    /**
     * Builder class for generating `Palette` instances.
     */
    public final class Builder {
        
        private let mSwatches: [Swatch]?
        private let mBitmap: CGImage?
        
        private var mTargets: [Target] = []
        
        private var mMaxColors = Palette27.defaultCalculateNumberColors
        private var mResizeArea = Palette27.defaultResizeBitmapArea
        private var mResizeMaxDimension = -1
        
        private var mFilters: [Filter] = []
        private var mRegion: CGRect?
        
        /**
         * Construct a new {@link Builder} using a source {@link Bitmap}
         */
        public init(bitmap: CGImage) {
            // if (bitmap == null || bitmap.isRecycled()) {
            //     throw new IllegalArgumentException("Bitmap is not valid");
            // }
            mFilters.append(Palette27.defaultFilter)
            mBitmap = bitmap
            mSwatches = nil
            
            // Add the default targets
            mTargets.append(Target.LIGHT_VIBRANT);
            mTargets.append(Target.VIBRANT);
            mTargets.append(Target.DARK_VIBRANT);
            mTargets.append(Target.LIGHT_MUTED);
            mTargets.append(Target.MUTED);
            mTargets.append(Target.DARK_MUTED);
        }
        
        /**
         * Construct a new {@link Builder} using a list of {@link Swatch} instances.
         * Typically only used for testing.
         */
        public init(swatches: [Swatch]) {
            if swatches.isEmpty {
                //throw new IllegalArgumentException("List of Swatches is not valid");
            }
            mFilters.append(Palette27.defaultFilter)
            mSwatches = swatches
            mBitmap = nil
        }
        
        /**
         * Set the maximum number of colors to use in the quantization step when using a
         * {@link android.graphics.Bitmap} as the source.
         * <p>
         * Good values for depend on the source image type. For landscapes, good values are in
         * the range 10-16. For images which are largely made up of people's faces then this
         * value should be increased to ~24.
         */
        public func maximumColorCount(colors: Int) -> Builder {
            mMaxColors = colors
            return self
        }
        
        /**
         * Set the resize value when using a {@link android.graphics.Bitmap} as the source.
         * If the bitmap's area is greater than the value specified, then the bitmap
         * will be resized so that its area matches {@code area}. If the
         * bitmap is smaller or equal, the original is used as-is.
         * <p>
         * This value has a large effect on the processing time. The larger the resized image is,
         * the greater time it will take to generate the palette. The smaller the image is, the
         * more detail is lost in the resulting image and thus less precision for color selection.
         *
         * @param area the number of pixels that the intermediary scaled down Bitmap should cover,
         *             or any value <= 0 to disable resizing.
         */
        public func resizeBitmapArea(area: Int) -> Builder {
            mResizeArea = area
            mResizeMaxDimension = -1
            return self
        }
        
        /**
         * Clear all added filters. This includes any default filters added automatically by
         * {@link Palette}.
         */
        public func clearFilters() -> Builder {
            mFilters.removeAll()
            return self
        }
        
        /**
         * Add a filter to be able to have fine grained control over which colors are
         * allowed in the resulting palette.
         *
         * @param filter filter to add.
         */
        public func addFilter(filter: Filter) -> Builder {
            mFilters.append(filter)
            return self
        }
        
        /**
         * Set a region of the bitmap to be used exclusively when calculating the palette.
         * <p>This only works when the original input is a {@link Bitmap}.</p>
         *
         * @param left The left side of the rectangle used for the region.
         * @param top The top of the rectangle used for the region.
         * @param right The right side of the rectangle used for the region.
         * @param bottom The bottom of the rectangle used for the region.
         */
        public func setRegion(left: Int, top: Int, right: Int, bottom: Int) -> Builder {
            guard let bitmap = mBitmap else {
                return self
            }
            
            if mRegion == nil {
                // Set the Rect to be initially the whole Bitmap
                mRegion = CGRect(x: 0, y: 0, width: bitmap.width, height: bitmap.height)
            }
            
            
            // Now just get the intersection with the region
            if mRegion!.intersects(CGRect(x: 0, y: 0, width: right - left, height: bottom - top)) {
//                throw new IllegalArgumentException("The given region must intersect with "
//                    + "the Bitmap's dimensions.");
            }
            return self
        }
    }
}

extension Palette27 {
    
    /**
     * Represents a color swatch generated from an image's palette. The RGB color can be retrieved
     * by calling {@link #getRgb()}.
     */
    public final class Swatch {
        
        public let red, green, blue: Int
        public let rgb: Int
        public let population: Int
        
        private var generatedTextColors: Bool = false
        
        public var titleTextColor: Int {
            get {
                ensureTextColorsGenerated()
                return _titleTextColor
            }
        }
        private var _titleTextColor = 0
        
        public var bodyTextColor: Int {
            get {
                ensureTextColorsGenerated()
                return _bodyTextColor
            }
        }
        private var _bodyTextColor = 0
        
        /**
         * Return this swatch's HSL values.
         *     hsv[0] is Hue [0 .. 360)
         *     hsv[1] is Saturation [0...1]
         *     hsv[2] is Lightness [0...1]
         */
        public var hsl: [Float] {
            get {
                var hsl = _hsl ?? [Float](repeating: 0, count: 3)
                
                //redundant? why google do this?
                ColorUtils27.RGBToHSL(r: red, g: green, b: blue, outHsl: &hsl);
                return hsl
            }
        }
        private var _hsl: [Float]?
        
        init(color: ColorInt, population: Int) {
            red = Color.red(color)
            green = Color.green(color)
            blue = Color.blue(color)
            rgb = color
            self.population = population
        }
        
        init(red: Int, green: Int, blue: Int, population: Int) {
            self.red = red
            self.green = green
            self.blue = blue
            self.rgb = Color.rgb(red: red, green: green, blue: blue)
            self.population = population
        }
        
        convenience init(hsl: [Float], population: Int) {
            self.init(color: ColorUtils27.HSLToColor(hsl), population: population)
            self._hsl = hsl
        }
        
        convenience init(color: UIColor, population: Int) {
            let components = color.cgColor.components!
            //TODO: just use Int(components[0] * 255.0 + 0.5) & 0xFF; ?
            self.init(red: Int(components[0] * 255.0 + 0.5) << 16,
                      green: Int(components[1] * 255.0 + 0.5) << 8,
                      blue: Int(components[2] * 255.0 + 0.5),
                      population: population)
        }
        
        private func ensureTextColorsGenerated() {
            if (!generatedTextColors) {
                // First check white, as most colors will be dark
                let lightBodyAlpha = ColorUtils27.calculateMinimumAlpha(
                    foreground: Color.WHITE,
                    background: rgb,
                    minContrastRatio: Palette27.minContrastBodyText)
                
                let lightTitleAlpha = ColorUtils27.calculateMinimumAlpha(
                    foreground: Color.WHITE,
                    background: rgb,
                    minContrastRatio: Palette27.minContrastTitleText)
                
                if (lightBodyAlpha != -1 && lightTitleAlpha != -1) {
                    // If we found valid light values, use them and return
                    _bodyTextColor = ColorUtils27.setAlphaComponent(color: Color.WHITE, alpha: lightBodyAlpha)
                    _titleTextColor = ColorUtils27.setAlphaComponent(color: Color.WHITE, alpha: lightTitleAlpha)
                    generatedTextColors = true
                    return
                }
                
                let darkBodyAlpha = ColorUtils27.calculateMinimumAlpha(
                    foreground: Color.BLACK,
                    background: rgb,
                    minContrastRatio: Palette27.minContrastBodyText)
                let darkTitleAlpha = ColorUtils27.calculateMinimumAlpha(
                    foreground: Color.BLACK,
                    background: rgb,
                    minContrastRatio: Palette27.minContrastTitleText)
                
                if (darkBodyAlpha != -1 && darkTitleAlpha != -1) {
                    // If we found valid dark values, use them and return
                    _bodyTextColor = ColorUtils27.setAlphaComponent(color: Color.BLACK, alpha: darkBodyAlpha)
                    _titleTextColor = ColorUtils27.setAlphaComponent(color: Color.BLACK, alpha: darkTitleAlpha);
                    generatedTextColors = true;
                    return
                }
                
                // If we reach here then we can not find title and body values which use the same
                // lightness, we need to use mismatched values
                _bodyTextColor = lightBodyAlpha != -1
                    ? ColorUtils27.setAlphaComponent(color: Color.WHITE, alpha: lightBodyAlpha)
                    : ColorUtils27.setAlphaComponent(color: Color.BLACK, alpha: darkBodyAlpha);
                _titleTextColor = lightTitleAlpha != -1
                    ? ColorUtils27.setAlphaComponent(color: Color.WHITE, alpha: lightTitleAlpha)
                    : ColorUtils27.setAlphaComponent(color: Color.BLACK, alpha: darkTitleAlpha);
                generatedTextColors = true;
            }
        }
        
    }
}

extension Palette27.Swatch: Hashable {
    
    public static func == (lhs: Palette27.Swatch, rhs: Palette27.Swatch) -> Bool {
        return lhs.population == rhs.population && lhs.rgb == rhs.rgb
    }
    
    public var hashValue: Int {
        return 31 * rgb + population;
    }
}

public protocol PaletteFilter {
    func isAllowed(_ rgb: Int, _ hsl: [Float]) -> Bool
}

extension Palette27 {
    
    static let defaultFilter = DefaultFilter()
    
    struct DefaultFilter: PaletteFilter {
        
        private static let blackMaxLightness: Float = 0.05
        private static let whiteMinLightness: Float = 0.95
        
        func isAllowed(_ rgb: Int, _ hsl: [Float]) -> Bool {
            return !isWhite(hsl) && !isBlack(hsl) && !isNearRedILine(hsl);
        }
        
        /**
         * @return true if the color represents a color which is close to black.
         */
        private func isBlack(_ hslColor: [Float]) -> Bool {
            return hslColor[2] <= Palette27.DefaultFilter.blackMaxLightness;
        }
        
        /**
         * @return true if the color represents a color which is close to white.
         */
        private func isWhite(_ hslColor: [Float]) -> Bool {
            return hslColor[2] >= Palette27.DefaultFilter.whiteMinLightness;
        }
        
        /**
         * @return true if the color lies close to the red side of the I line.
         */
        private func isNearRedILine(_ hslColor: [Float]) -> Bool {
            return hslColor[0] >= 10 && hslColor[0] <= 37 && hslColor[1] <= 0.82;
        }
    }
}
