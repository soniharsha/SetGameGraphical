//
//  CardView.swift
//  SetGameModified
//
//  Created by Harsha on 27/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var shape: String? = "Circle"
    var color: UIColor? = UIColor.red
    var number: CGFloat? = 3.0
    var shade: String? = "Strip"
    
    func fillColor(at path: UIBezierPath, _ color: UIColor, with shade: String){
        path.addClip()
        color.setFill()
        color.setStroke()
        
        switch shade {
        case "Fill": path.fill()
        case "Outline": path.stroke()
        case "Strip":
            var Y = bounds.minY
            while Y < bounds.maxY {
                path.move(to: CGPoint(x: bounds.minX, y: Y))
                path.addLine(to: CGPoint(x: bounds.maxX, y: Y))
                Y += 5
                path.stroke()
            }
        default: path.stroke(); path.fill()
        }
    }
    
    func centreAttributed(_ shape: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return NSAttributedString(string: shape, attributes: [.font: font, .paragraphStyle: paragraph])
    }
    
    func drawCircle(at path: UIBezierPath, width: CGFloat, height: CGFloat, emojiRect: CGRect, area: CGFloat) {
        let radius: CGFloat =  sqrt((area * Constants.areaToShapeRatio) / (2 * 3.14))
        let spacing = radius * (Constants.spacingBetweenShapes)
        switch (number!) {
        case 1: path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        case 2: path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY - radius - spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY + radius + spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        case 3: path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY - 2 * radius - spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY + 2 * radius + spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        default: break
        }
    }
    
    func drawSingleSquare(at path: UIBezierPath, x: CGFloat, y: CGFloat, with side: CGFloat) {
        path.addLine(to: CGPoint(x: x + side, y: y))
        path.addLine(to: CGPoint(x: x + side, y: y + side))
        path.addLine(to: CGPoint(x: x, y: y + side))
        path.close()
    }
    
    func drawSquare(at path: UIBezierPath, width: CGFloat, height: CGFloat, emojiRect: CGRect, area: CGFloat) {
        let side = sqrt(area * Constants.areaToShapeRatio)
        let spacing = side * (Constants.spacingBetweenShapes)
        let initialx = (width - side) / 2
        let initialy = (height - number! * side - (number! - CGFloat(1)) * spacing) / 2
        switch (number!) {
        case 1:
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy))
            drawSingleSquare(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy, with: side)
        case 2:
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy))
            drawSingleSquare(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy, with: side)
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side + spacing))
            drawSingleSquare(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side + spacing, with: side)
        case 3:
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy))
            drawSingleSquare(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy, with: side)
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side + spacing))
            drawSingleSquare(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side + spacing, with: side)
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + 2 * side + 2 * spacing))
            drawSingleSquare(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + 2 * side + 2 * spacing, with: side)
        default: break
        }
    }
    
    func drawStar(at path: UIBezierPath, width: CGFloat, height: CGFloat, emojiRect: CGRect, area: CGFloat) {
        let side = sqrt(area * Constants.areaToShapeRatio)
        let spacing = side * (Constants.spacingBetweenShapes)
        let initialx = (width - side) / 2
        let initialy = (height - number! * side - (number! - CGFloat(1)) * spacing) / 2
        switch (number!) {
        case 1:
                path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy))
                path.addCurve(to: CGPoint(x: emojiRect.origin.x + initialx + side, y: emojiRect.origin.y + initialy + side), controlPoint1: CGPoint(x: emojiRect.origin.x + initialx , y: emojiRect.origin.y + initialy + spacing), controlPoint2: CGPoint(x: emojiRect.origin.x + initialx , y: emojiRect.origin.y + initialy - spacing))
        default: break
        }
    }
    
    func drawEmoji(at path: UIBezierPath) {
        let emojiRect = bounds.insetBy(dx: cornerOffSet, dy: cornerOffSet)
        let width = emojiRect.width, height = emojiRect.height
        let area = width * height
        switch shape! {
        case "Circle": drawCircle(at: path, width: width, height: height, emojiRect: emojiRect, area: area)
        case "Square": drawSquare(at: path, width: width, height: height, emojiRect: emojiRect, area: area)
        case "Star": drawStar(at: path, width: width, height: height, emojiRect: emojiRect, area: area)
        default: break
        }
        
        fillColor(at: path, color!, with: shade!)
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardsCornerRadius)
        UIColor.white.setFill()
        roundedRect.fill()
        let path = UIBezierPath()
        drawEmoji(at: path)
    }
}


extension CardView {
    private struct Constants {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.08
        static let cornerOffSetToCornerRadius: CGFloat = 0.40
        static let spacingBetweenShapes: CGFloat = 0.2
        static let areaToShapeRatio: CGFloat = 0.1
    }
    
    private var cardsCornerRadius: CGFloat {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffSet: CGFloat {
        return cardsCornerRadius * Constants.cornerOffSetToCornerRadius
    }
    
    private var areaOfView: CGFloat {
        return bounds.height * bounds.width
    }
}
