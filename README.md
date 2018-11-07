# Palette
Generates a palette by extracting color swatches from an image.

Palette is a Swift port of Android's [Palette](https://developer.android.com/reference/android/support/v7/graphics/Palette.html) class.

##Usage

```swift
let palette = Palette(uiImage: image)
            
let maybeSwatches = [
    palette.getVibrantSwatch(),
    palette.getMutedSwatch(),
    palette.getLightVibrantSwatch(),
    palette.getLightMutedSwatch(),
    palette.getDarkVibrantSwatch(),
    palette.getDarkMutedSwatch()]

var swatches: [Palette.Swatch] = []

for swatch in maybeSwatches {
    if let swatch = swatch {
        swatches.append(swatch)
    }
}
```

##License
MIT
