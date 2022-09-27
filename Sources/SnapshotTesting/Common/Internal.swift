#if os(macOS)
import Cocoa
typealias Image = NSImage
typealias ImageView = NSImageView
typealias View = NSView
extension NSImage {
  var cgImage: CGImage? {
    cgImage(forProposedRect: nil, context: nil, hints: nil)
  }
}
#elseif os(iOS) || os(tvOS)
import UIKit
typealias Image = UIImage
typealias ImageView = UIImageView
typealias View = UIView
#endif
