import UIKit

let speedLimit = "60"
let signSize: CGFloat = 300

let borderRatio: CGFloat = 0.1
let borderColor = UIColor(red: 228 / 255, green: 50 / 255, blue: 45 / 255, alpha: 1)
let backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 254 / 255, alpha: 1)
let shadowBlur: CGFloat = 20
let shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
let textColor = UIColor(red: 24 / 255, green: 23 / 255, blue: 23 / 255, alpha: 1)
let fontName = "Avenir"

UIGraphicsBeginImageContext(CGSize(width: signSize + 2 * shadowBlur, height: signSize + 2 * shadowBlur))
let context = UIGraphicsGetCurrentContext()!

context.setShadow(offset: CGSize(width: 0, height: 0), blur: shadowBlur, color: shadowColor)
context.beginTransparencyLayer(in: CGRect(x: shadowBlur, y: shadowBlur, width: signSize, height: signSize), auxiliaryInfo: nil)

let borderWidth = borderRatio * signSize * 2
let board = UIBezierPath(ovalIn: CGRect(x: borderWidth / 2 + shadowBlur, y: borderWidth / 2 + shadowBlur, width: signSize - borderWidth, height: signSize - borderWidth))
board.lineWidth = borderWidth
borderColor.setStroke()
backgroundColor.setFill()
board.stroke()
board.fill()

let fontSize = speedLimit.count <= 2 ? 0.75 * board.bounds.width : 0.55 * board.bounds.width
let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: fontSize)!,
                                                 .foregroundColor: textColor]
let stringSize = (speedLimit as NSString).size(withAttributes: attributes)
let stringPosition = CGPoint(x: (signSize - stringSize.width) / 2 + shadowBlur, y: (signSize - stringSize.height) / 2 + shadowBlur)
let attributedString = NSMutableAttributedString(string: speedLimit, attributes: attributes)

if speedLimit.starts(with: "1") {
    attributedString.addAttribute(.kern, value: -5, range: NSRange(location: 0, length: 1))
}

attributedString.draw(at: stringPosition)

context.endTransparencyLayer()

let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
