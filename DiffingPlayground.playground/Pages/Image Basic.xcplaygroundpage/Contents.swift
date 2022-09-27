import CoreImage
@testable import SnapshotTesting

// Place images in the "Resources" folder
let image1 = Image(named: "1.reference")!
let image2 = Image(named: "1.actual")!

let failureMessage = perceptuallyCompare(
  CIImage(cgImage: image1.cgImage!),
  CIImage(cgImage: image2.cgImage!),
  pixelPrecision: 1.0,
  perceptualPrecision: 0.98
)

if let failureMessage = failureMessage {
  print("❌ \(failureMessage)")
  diff(image1, image2)
} else {
  print("✅ Images matched")
}
