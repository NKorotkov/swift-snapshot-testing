import CoreImage

extension CIImage {
  public func max(percentage: Float, context: CIContext) -> Float {
    let pixelCount = Int(extent.width * extent.height)
    var bitmap = [Float](repeating: 0, count: pixelCount)
    context.render(
      self,
      toBitmap: &bitmap,
      rowBytes: MemoryLayout<Float>.size * Int(extent.width),
      bounds: extent,
      format: .Rf,
      colorSpace: nil
    )
    return bitmap.max(k: Int(percentage * Float(pixelCount)))
  }
}
