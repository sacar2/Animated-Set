//
//  Card.swift
//  2019-03-12_Assignment1-Concentration
//
//  Created by Selin Denise Acar on 2019-03-12.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int{ return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    var hasBeenFlipped = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1 //you're in a static method so you can access the var without "card."
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
