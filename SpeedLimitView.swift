//
//  SpeedLimitView.swift
//  Obserwator
//
//  Created by Kamil Chmielewski on 21/04/2020.
//  Copyright © 2020 Kamil Chmielewski. All rights reserved.
//

import UIKit

@IBDesignable
class SpeedLimitView: UIView {
    
    static let borderRatio: CGFloat = 0.1
    static let borderColor = UIColor(red: 228 / 255, green: 50 / 255, blue: 45 / 255, alpha: 1)
    static let boardBackgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 254 / 255, alpha: 1)
    static let shadowBlur: CGFloat = 20
    static let shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
    static let textColor = UIColor(red: 24 / 255, green: 23 / 255, blue: 23 / 255, alpha: 1)
    static let fontName = "Avenir"
    static let hideAnimationDuration = 0.2
    static let showAnimationDuration = 0.3
    static let springAnimationDamping: CGFloat = 0.7
    static let springAnimationInitialVelocity: CGFloat = 2 / 3
    
    private var shouldShowAgainAfterHiding = false
    var speedLimit = "60" {
        didSet {
            // If needed, animate every speed limit change.
            if !isHidden && speedLimit != oldValue {
                updateSpeedLimit()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let signSize = rect.width - 2 * SpeedLimitView.shadowBlur
        let context = UIGraphicsGetCurrentContext()!

        // Set a sign shadow.
        context.setShadow(offset: CGSize(width: 0, height: 0), blur: SpeedLimitView.shadowBlur, color: SpeedLimitView.shadowColor)
        context.beginTransparencyLayer(in: CGRect(x: SpeedLimitView.shadowBlur, y: SpeedLimitView.shadowBlur, width: signSize, height: signSize), auxiliaryInfo: nil)

        // Draw a sign board.
        let borderWidth = SpeedLimitView.borderRatio * signSize * 2
        let board = UIBezierPath(ovalIn: CGRect(x: borderWidth / 2 + SpeedLimitView.shadowBlur, y: borderWidth / 2 + SpeedLimitView.shadowBlur, width: signSize - borderWidth, height: signSize - borderWidth))
        board.lineWidth = borderWidth
        SpeedLimitView.borderColor.setStroke()
        SpeedLimitView.boardBackgroundColor.setFill()
        board.stroke()
        board.fill()

        // Draw a text representing the current speed limit.
        let fontSize = speedLimit.count <= 2 ? 0.75 * board.bounds.width : 0.55 * board.bounds.width
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: SpeedLimitView.fontName, size: fontSize)!, .foregroundColor: SpeedLimitView.textColor]
        let stringSize = (speedLimit as NSString).size(withAttributes: attributes)
        let stringPosition = CGPoint(x: (signSize - stringSize.width) / 2 + SpeedLimitView.shadowBlur, y: (signSize - stringSize.height) / 2 + SpeedLimitView.shadowBlur)
        let attributedString = NSMutableAttributedString(string: speedLimit, attributes: attributes)

        // Apply a visual fix for speed limits starting with "1".
        if speedLimit.starts(with: "1") {
            attributedString.addAttribute(.kern, value: -5, range: NSRange(location: 0, length: 1))
        }

        attributedString.draw(at: stringPosition)

        context.endTransparencyLayer()
    }
    
    private func updateSpeedLimit() {
        shouldShowAgainAfterHiding = true
        hide()
    }
    
    func show() {
        guard isHidden else { return }
        
        // Set initial appearance for animation.
        layer.opacity = 0
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        // Show the sign and update its speed limit.
        isHidden = false
        setNeedsDisplay()
        
        UIView.animate(withDuration: SpeedLimitView.showAnimationDuration, delay: 0, usingSpringWithDamping: SpeedLimitView.springAnimationDamping, initialSpringVelocity: SpeedLimitView.springAnimationInitialVelocity, options: [], animations: {
            // Make the sign visible while scaling it up.
            self.layer.opacity = 1
            self.transform = .identity
        }, completion: nil)
    }
    
    func hide() {
        guard !isHidden else { return }
        
        UIView.animate(withDuration: SpeedLimitView.hideAnimationDuration, delay: 0, options: .curveEaseIn, animations: {
            // Make the sign invisible while scaling it down.
            self.layer.opacity = 0
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { _ in
            self.isHidden = true
            
            // If the speed limit has changed, show the sign again.
            if self.shouldShowAgainAfterHiding {
                self.shouldShowAgainAfterHiding = false
                self.show()
            }
        })
    }
    
}
