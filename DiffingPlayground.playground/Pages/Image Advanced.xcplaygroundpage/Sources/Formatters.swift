import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Float> {
  public static var precision: Self {
    number.rounded(rule: .down, increment: 0.0001)
  }

  public static var precisionPercent: FloatingPointFormatStyle<Float>.Percent {
    Self.Percent().rounded(rule: .down, increment: 0.01)
  }
}
