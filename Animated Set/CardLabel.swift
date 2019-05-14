//
//  CardLabel.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-05-10.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class CardLabel: UILabel {
    var symbol: SetCard.Symbol = SetCard.Symbol.oval
    var color: UIColor = UIColor.clear
    var numberOfShapes: Int = 0
    var shading: SetCard.Shading = SetCard.Shading.open
    
    convenience init(frame: CGRect, symbol: SetCard.Symbol, color: UIColor, numberOfShapes: Int, shading: SetCard.Shading){
        self.init(frame: frame)
        self.symbol = symbol
        self.color = color
        self.numberOfShapes = numberOfShapes
        self.shading = shading
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let insetValue: CGFloat = 0.8
        let insetRect = CGRect(origin: CGPoint(x: rect.origin.x + (rect.width*((1-insetValue)/2)), y: rect.origin.y), size: CGSize(width: rect.width*insetValue, height: rect.height*insetValue))
        let thirdWidth = insetRect.width / 3
        let symbolHeight = insetRect.height * insetValue
        var symbolWidth = thirdWidth * insetValue
        let cardCenterHeight = rect.height / 2 - symbolHeight / 2
        
        for shapeNumber in 1...numberOfShapes{
            if symbol == SetCard.Symbol.squiggle{
                symbolWidth = thirdWidth
                let originX = insetRect.origin.x + CGFloat(shapeNumber - 1) * thirdWidth
                let originY = cardCenterHeight
                path.move(to: CGPoint(x: originX + symbolWidth / 3,
                                      y: originY))
                //2
                path.addCurve(to: CGPoint(x: originX + symbolWidth * 3 / 4,
                                          y: originY + symbolHeight / 2),
                              controlPoint1: CGPoint(x: originX + symbolWidth * 7 / 8,
                                                     y: originY),
                              controlPoint2: CGPoint(x: originX + symbolWidth,
                                                     y: originY + symbolHeight / 4))
                //3
                path.addCurve(to: CGPoint(x: originX + symbolWidth * 3 / 4,
                                          y: originY + symbolHeight * 3 / 4),
                              controlPoint1: CGPoint(x: originX + symbolWidth * 2 / 3,
                                                     y: originY + symbolHeight * 7 / 12),
                              controlPoint2: CGPoint(x: originX + symbolWidth * 2 / 3,
                                                     y: originY + symbolHeight * 2 / 3))
                //4
                path.addCurve(to: CGPoint(x: originX + symbolWidth * 2 / 3,
                                          y: originY + symbolHeight),
                              controlPoint1: CGPoint(x: originX + symbolWidth,
                                                     y: originY + symbolHeight * 7 / 8),
                              controlPoint2: CGPoint(x: originX + symbolWidth,
                                                     y: originY + symbolHeight))
                //5
                path.addCurve(to: CGPoint(x: originX + symbolWidth / 4,
                                          y: originY + symbolHeight / 2),
                              controlPoint1: CGPoint(x: originX + symbolWidth / 8,
                                                     y: originY + symbolHeight),
                              controlPoint2: CGPoint(x: originX,
                                                     y: originY + symbolHeight * 3 / 4))

                //6
                path.addCurve(to: CGPoint(x: originX + symbolWidth / 4,
                                          y: originY + symbolHeight / 4),
                              controlPoint1: CGPoint(x: originX + symbolWidth / 3,
                                                     y: originY + symbolHeight * 5 / 12),
                              controlPoint2: CGPoint(x: originX + symbolWidth / 3,
                                                     y: originY + symbolHeight / 3))
                // 7
                path.addCurve(to: CGPoint(x: originX + symbolWidth / 3,
                                          y: originY ),
                              controlPoint1: CGPoint(x: originX,
                                                     y: originY + symbolHeight / 8),
                              controlPoint2: CGPoint(x: originX,
                                                     y: originY))
            }else if symbol == SetCard.Symbol.diamond{
                let diamondOriginX = insetRect.origin.x + (CGFloat(shapeNumber) * thirdWidth )
                path.move(to: CGPoint(x: diamondOriginX - (symbolWidth / 2), y: cardCenterHeight))
                path.addLine(to: CGPoint(x: diamondOriginX, y: cardCenterHeight + symbolHeight / 2))
                path.addLine(to: CGPoint(x: diamondOriginX - (symbolWidth / 2), y: cardCenterHeight + symbolHeight))
                path.addLine(to: CGPoint(x: diamondOriginX - symbolWidth, y: cardCenterHeight + symbolHeight / 2))
                path.close()
            }else if symbol == SetCard.Symbol.oval{
                let ovalOrigin = CGPoint(x: insetRect.origin.x + (CGFloat(shapeNumber - 1) * thirdWidth), y: cardCenterHeight)
                let calculatedRect = CGRect(origin: ovalOrigin, size: CGSize(width: symbolWidth, height: symbolHeight))
                path.append(UIBezierPath(roundedRect: calculatedRect, cornerRadius: 20.0))
            }
        }

        if shading == SetCard.Shading.open{
            color.setStroke()
            path.lineWidth = CGFloat(2.0)
            path.stroke()
        }else if shading == SetCard.Shading.solid{
            color.setFill()
            path.fill()
        }else if shading == SetCard.Shading.striped{
            let stripes = UIBezierPath()
            let numberOfLines: CGFloat = 6
            
            for lineNumber in stride(from: 0, to: rect.height, by: symbolHeight / numberOfLines){
                let yPosition2 = insetRect.origin.y + lineNumber
                stripes.move(to: CGPoint(x: insetRect.origin.x, y: yPosition2))
                stripes.addLine(to: CGPoint(x: insetRect.origin.x + insetRect.width, y: yPosition2))
            }
            stripes.lineWidth = CGFloat(3.0)
            color.setStroke()
            path.addClip()
            stripes.stroke()
            path.stroke()
        }
    }
    
    func updateCardAttributes(withSymbol symbol: SetCard.Symbol, color: UIColor, numberOfShapes: Int, shading: SetCard.Shading){
        self.symbol = symbol
        self.color = color
        self.numberOfShapes = numberOfShapes
        self.shading = shading
    }
}
