//
//  SetCard.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-03-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

struct SetCard{
    enum Symbol: String{
//        case diamonds
//        case crescent
//        case star
        case square = "■"
        case triangle = "▲"
        case circle =  "●"
    }
    
    enum Shading{
        case solid
        case open
        case striped
    }
    
    var symbol: Symbol
    var number: Int
    var shading: Shading
    var color: UIColor
    
    init(withSymbol symbolValue: Symbol, withNumberOfSymbols symbolCount: Int, hasShading shadingValue: Shading, withColor colorValue: UIColor) {
        symbol = symbolValue
        number = symbolCount
        shading = shadingValue
        color = colorValue
    }
}

extension SetCard.Symbol: CaseIterable{}
extension SetCard.Shading: CaseIterable{}
