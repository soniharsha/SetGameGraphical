//
//  CardView.swift
//  SetGameModified
//
//  Created by Harsha on 27/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var card: Card
    var selected: Bool { didSet { tapped() } }
    var hint = false { didSet { tapped() } }
    var faceUp = false { didSet { tapped() }}
    
    init(frame: CGRect, card: Card, selected: Bool) {
        self.card = card
        self.selected = selected
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func tapped() {
        setNeedsDisplay()
    }
    
    private func fillColor(at path: UIBezierPath, _ color: UIColor, with shade: String){
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
        default: path.fill()
        }
    }
    
    private func centreAttributed(_ shape: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return NSAttributedString(string: shape, attributes: [.font: font, .paragraphStyle: paragraph])
    }
    
    private func drawCircle(at path: UIBezierPath, width: CGFloat, height: CGFloat, emojiRect: CGRect) {
        var radius: CGFloat =  (height * ConstantCardView.heightToShapeRatio) / 2
        if(2 * radius > width){
            radius = width / 4
        }
        let spacing = radius * (ConstantCardView.spacingBetweenShapes)
        
        switch card.number.value {
        case 1: path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        case 2: path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY - radius - spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY + radius + spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        case 3: path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY - 2 * radius - spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: emojiRect.midX, y: emojiRect.midY + 2 * radius + spacing), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        default: break
        }
    }
    
    private func drawSingleSquare(at path: UIBezierPath, x: CGFloat, y: CGFloat, with side: CGFloat) {
        path.addLine(to: CGPoint(x: x + side, y: y))
        path.addLine(to: CGPoint(x: x + side, y: y + side))
        path.addLine(to: CGPoint(x: x, y: y + side))
        path.close()
    }
    
    private func drawSquare(at path: UIBezierPath, width: CGFloat, height: CGFloat, emojiRect: CGRect) {
        var side = (height * ConstantCardView.heightToShapeRatio)
        let spacing = side * (ConstantCardView.spacingBetweenShapes)
        if(side > width){
            side = width/2
        }
        let initialx = (width - side) / 2
        let initialy = (height - card.number.value * side - (card.number.value - CGFloat(1)) * spacing) / 2
        switch card.number.value {
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
    
    private func drawSingleStar(at path: UIBezierPath, x: CGFloat, y: CGFloat, with side: CGFloat){
        path.addLine(to: CGPoint(x: x + side / 2, y: y - side))
        path.addLine(to: CGPoint(x: x + side, y: y))
        path.close()
    }
    
    private func drawStar(at path: UIBezierPath, width: CGFloat, height: CGFloat, emojiRect: CGRect) {
        var side = (height * ConstantCardView.heightToShapeRatio)
        let spacing = side * (ConstantCardView.spacingBetweenShapes)
        if(side > width){
            side = width/2
        }
        let initialx = (width - side) / 2
        let initialy = (height - card.number.value * side - (card.number.value - CGFloat(1)) * spacing) / 2
        switch card.number.value {
        case 1:
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side))
            drawSingleStar(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side, with: side)
        case 2:
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side))
            drawSingleStar(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side, with: side)
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + spacing + 2 * side))
            drawSingleStar(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + spacing + 2 * side, with: side)
        case 3:
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side))
            drawSingleStar(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + side, with: side)
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + spacing + 2 * side))
            drawSingleStar(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + spacing + 2 * side, with: side)
            path.move(to: CGPoint(x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + 2 * spacing + 3 * side))
            drawSingleStar(at: path, x: emojiRect.origin.x + initialx, y: emojiRect.origin.y + initialy + 2 * spacing + 3 * side, with: side)
        default: break
        }
    }
    
    private func drawEmoji(at path: UIBezierPath) {
        let emojiRect = bounds.insetBy(dx: cornerOffSet, dy: cornerOffSet)
        let width = emojiRect.width, height = emojiRect.height
        switch card.shape.value {
        case "Circle": drawCircle(at: path, width: width, height: height, emojiRect: emojiRect)
        case "Square": drawSquare(at: path, width: width, height: height, emojiRect: emojiRect)
        case "Star": drawStar(at: path, width: width, height: height, emojiRect: emojiRect)
        default: break
        }
        
        fillColor(at: path, card.color.value, with: card.shade.value)
    }
    
    override func draw(_ rect: CGRect) {
        if hint, faceUp {
            let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardsCornerRadius)
            UIColor.cyan.setFill()
            roundedRect.fill()
            let path = UIBezierPath()
            drawEmoji(at: path)
        } else if !hint, !faceUp {
            if let cardImage = UIImage(named: "faceDown"){
                cardImage.draw(in: bounds)
            }
        } else {
            if !selected {
                let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardsCornerRadius)
                UIColor.white.setFill()
                roundedRect.fill()
                let path = UIBezierPath()
                drawEmoji(at: path)
            } else {
                let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardsCornerRadius)
                UIColor.blue.setStroke()
                UIColor.white.setFill()
                roundedRect.fill()
                roundedRect.lineWidth = lineWidth
                roundedRect.stroke()
                let path = UIBezierPath()
                drawEmoji(at: path)
            }
        }
    }
}


extension CardView {
    private struct ConstantCardView {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.08
        static let cornerOffSetToCornerRadius: CGFloat = 0.40
        static let spacingBetweenShapes: CGFloat = 0.2
        static let heightToShapeRatio: CGFloat = 0.25
        static let cornerOffSetToBorderRatio: CGFloat = 0.8
    }
    
    private var lineWidth: CGFloat {
        return cornerOffSet * ConstantCardView.cornerOffSetToBorderRatio
    }
    
    private var cardsCornerRadius: CGFloat {
        return bounds.size.height * ConstantCardView.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffSet: CGFloat {
        return cardsCornerRadius * ConstantCardView.cornerOffSetToCornerRadius
    }
    
    private var areaOfView: CGFloat {
        return bounds.height * bounds.width
    }
}


