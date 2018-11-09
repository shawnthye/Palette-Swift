//
//  Target.swift
//  Palette
//
//  Created by Shawn Thye on 09/11/2018.
//  Copyright © 2018 Jonathan Zong. All rights reserved.
//

import Foundation

/**
 * A class which allows custom selection of colors in a {@link Palette}'s generation. Instances
 * can be created via the {@link Builder} class.
 *
 * <p>To use the target, use the {@link Palette.Builder#addTarget(Target)} API when building a
 * Palette.</p>
 */
public class Target {
    private static let TARGET_DARK_LUMA: Float = 0.26;
    private static let MAX_DARK_LUMA: Float = 0.45;
    
    private static let MIN_LIGHT_LUMA: Float = 0.55;
    private static let TARGET_LIGHT_LUMA: Float = 0.74;
    
    private static let MIN_NORMAL_LUMA: Float = 0.3;
    private static let TARGET_NORMAL_LUMA: Float = 0.5;
    private static let MAX_NORMAL_LUMA: Float = 0.7;
    
    private static let TARGET_MUTED_SATURATION: Float = 0.3;
    private static let MAX_MUTED_SATURATION: Float = 0.4;
    
    private static let TARGET_VIBRANT_SATURATION: Float = 1
    private static let MIN_VIBRANT_SATURATION: Float = 0.35;
    
    private static let WEIGHT_SATURATION: Float = 0.24;
    private static let WEIGHT_LUMA: Float = 0.52;
    private static let WEIGHT_POPULATION: Float = 0.24;
    
    static let INDEX_MIN: Int = 0;
    static let INDEX_TARGET: Int = 1;
    static let INDEX_MAX: Int = 2;
    
    static let INDEX_WEIGHT_SAT: Int = 0;
    static let INDEX_WEIGHT_LUMA: Int = 1;
    static let INDEX_WEIGHT_POP: Int = 2;
    
    private var mSaturationTargets = [Float](repeating: 0, count: 3)
    private var mLightnessTargets = [Float](repeating: 0, count: 3)
    private var mWeights = [Float](repeating: 0, count: 3)
    
    private var mIsExclusive = true // default to true
    
    required init() {
        Target.setTargetDefaultValues(&mSaturationTargets);
        Target.setTargetDefaultValues(&mLightnessTargets);
    }
    
    required init(from: Target) {
        mSaturationTargets = [Float](from.mSaturationTargets)
        mLightnessTargets = [Float](from.mLightnessTargets)
        mWeights = [Float](from.mWeights)
    }
    /**
     * The minimum saturation value for this target.
     * - @FloatRange(from = 0, to = 1)
     */
    public var minimumSaturation: Float {
        get { return mSaturationTargets[Target.INDEX_MIN] }
    }
    
    /**
     * The target saturation value for this target.
     * - @FloatRange(from = 0, to = 1)
     */
    public var targetSaturation: Float {
        get { return mSaturationTargets[Target.INDEX_TARGET] }
    }
    
    /**
     * The maximum saturation value for this target.
     * - @FloatRange(from = 0, to = 1)
     */
    public var maximumSaturation: Float {
        get { return mSaturationTargets[Target.INDEX_MAX] }
    }
    
    /**
     * The minimum lightness value for this target.
     * - @FloatRange(from = 0, to = 1)
     */
    public var minimumLightness: Float {
        get { return mLightnessTargets[Target.INDEX_MIN] }
    }
    
    /**
     * The target lightness value for this target.
     * - @FloatRange(from = 0, to = 1)
     */
    public var targetLightness: Float {
        get { return mLightnessTargets[Target.INDEX_TARGET] }
    }
    
    /**
     * The maximum lightness value for this target.
     * - @FloatRange(from = 0, to = 1)
     */
    public var maximumLightness: Float {
        get { return mLightnessTargets[Target.INDEX_MAX] }
    }
    
    /**
     * Returns the weight of importance that this target places on a color's saturation within
     * the image.
     *
     * <p>The larger the weight, relative to the other weights, the more important that a color
     * being close to the target value has on selection.</p>
     *
     * @see #getTargetSaturation()
     */
    public var saturationWeight: Float {
    return mWeights[INDEX_WEIGHT_SAT];
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    private static func setTargetDefaultValues(_ values: inout [Float]) {
        values[INDEX_MIN] = 0;
        values[INDEX_TARGET] = 0.5;
        values[INDEX_MAX] = 1;
    }
    
    private func setDefaultWeights() {
        mWeights[Target.INDEX_WEIGHT_SAT] = Target.WEIGHT_SATURATION;
        mWeights[Target.INDEX_WEIGHT_LUMA] = Target.WEIGHT_LUMA;
        mWeights[Target.INDEX_WEIGHT_POP] = Target.WEIGHT_POPULATION;
    }
}
