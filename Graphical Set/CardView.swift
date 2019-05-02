//
//  CardView.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-05-02.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class CardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor.clear
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        let cardFramePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 5.0, y: 5.0), size: CGSize(width: bounds.width-10.0, height: bounds.height-10.0)), cornerRadius: 20.0)
        cardFramePath.addClip()
        UIColor.white.setFill()
        cardFramePath.fill()
    }

}
