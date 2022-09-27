import CoreImage
@testable import SnapshotTesting

// Place images in the "Resources" folder
let image1 = Image(named: "2.reference")!
let image2 = Image(named: "2.actual")!

// Adjust the precision values here.
let precision: Float = 1.0
let perceptualPrecision: Float = 0.98

let deltaThreshold = (1 - perceptualPrecision) * 100

// The more opaque/lighter the pixels, the more of a difference.
let deltaOutputImage = CIImage(cgImage: image1.cgImage!).applyingLabDeltaE(CIImage(cgImage: image2.cgImage!))

// Transparent/black pixels are passing the perceptual precision threshold, white pixels are not.
let thresholdOutputImage = try deltaOutputImage.applyingThreshold(deltaThreshold)

let context = CIContext(options: [.workingColorSpace: NSNull(), .outputColorSpace: NSNull()])
let averagePixel = thresholdOutputImage.applyingAreaAverage().renderSingleValue(in: context) ?? .nan
let actualPixelPrecision = 1 - averagePixel
let maximumDeltaE = deltaOutputImage.applyingAreaMaximum().renderSingleValue(in: context) ?? .nan
let minimumPerceptualPrecision = 1 - min(maximumDeltaE / 100, 1)

if actualPixelPrecision >= precision {
  print("✅ Images match")
  if precision < 1 {
    let matchingPerceptualPercentage = 1 - deltaOutputImage.max(percentage: (1 - precision), context: context) / 100
      if matchingPerceptualPercentage >= perceptualPrecision {
        print(
          """
          The images would still match if:
            1. precision is raised to \(actualPixelPrecision.formatted(.precision))
            2. perceptualPrecision is raised to \(matchingPerceptualPercentage.formatted(.precision))
            3. precision is raised to 1.0 and perceptualPrecision is set to \(minimumPerceptualPrecision.formatted(.precision))
          """
        )
      }
  } else if actualPixelPrecision >= precision || minimumPerceptualPrecision >= perceptualPrecision {
    print(
      """
      The images would still match if either:
        1. precision is raised to \(actualPixelPrecision.formatted(.precision))
        2. perceptualPrecision is raised to \(minimumPerceptualPrecision.formatted(.precision))
      """
    )
  }
} else {
  print("❌ Images do not match…")
  diff(image1, image2)
  if precision < 1 {
    let matchingPerceptualPercentage = 1 - min(deltaOutputImage.max(percentage: (1 - precision), context: context) / 100, 1)
    print(
      """
      The images would match if either:
        1. precision is lowered to \(actualPixelPrecision.formatted(.precision))
        2. perceptualPrecision is lowered to \(matchingPerceptualPercentage.formatted(.precision))
        3. precision is raised to 1.0 and perceptualPrecision is lowered to \(minimumPerceptualPrecision.formatted(.precision))
      """
    )
  } else {
    print(
      """
      The images would match if either:
        1. precision is lowered to \(actualPixelPrecision.formatted(.precision))
        2. perceptualPrecision is lowered to \(minimumPerceptualPrecision.formatted(.precision))
      """
    )
  }
}

print("ℹ️ \(actualPixelPrecision.formatted(.precisionPercent)) of pixels match with \(perceptualPrecision.formatted(.precisionPercent)) perceptual color precision")
