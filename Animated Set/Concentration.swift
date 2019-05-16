//
//  Concentration.swift
//  2019-03-12_Assignment1-Concentration
//
//  Created by Selin Denise Acar on 2019-03-12.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import Foundation

class Concentration{
    private(set) var cards = Array<Card>()
    private(set) var score = 0
    private(set) var flipCount = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set{ //when index of a one and only card is set, set status for faceup of all cards to false, except for the faceup card ofc.
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
//    
//    func isFaceUp(index: Int) -> Bool {
//        return cards[index].isFaceUp
//    }
    
    //this is our public api! people need to choose card from the interface so the controller needs to call this!
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at:\(index)) invalid - index out of bounds")
        if !cards[index].isMatched {
            //if its not matched and there is no cards up, or one card up, and the card chosen isnt already teh card that is up add to flip count
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {//if theres a card faceup and second click isnt on the one and only face up card
                    flipCount += 1
                    if cards[matchIndex] == cards[index]{ //if the cards match
                        cards[matchIndex].isMatched = true //set the is matched properties to true
                        cards[index].isMatched = true
                        updateScore(withPoints: 2)
                    }else{//cards don't match
                        
                    //if card hasn't been flipped before
                    if cards[index].hasBeenFlipped {
                        updateScore(withPoints: -1)
                    }else{
                        cards[index].hasBeenFlipped = true
                    }
                    
                    if cards[matchIndex].hasBeenFlipped{
                        updateScore(withPoints: -1)
                    }else{
                        cards[matchIndex].hasBeenFlipped = true
                    }
                }
                cards[index].isFaceUp = true
                
//                indexOfOneAndOnlyFaceUpCard = nil //Dont need this because it only ever needs to get set whenever we check its value anyways, which is done everytime this function is called and the card isn't a matched card
            }else{//if there's no cards up or the second touch is the one and only face up card
                if indexOfOneAndOnlyFaceUpCard == nil {
                    flipCount += 1
                }
                indexOfOneAndOnlyFaceUpCard = index // set it to the only face up card || update which cards are face up
            }
        }
    }
    
    func updateScore(withPoints points: Int){
        score += points
    }
    
    init(numberOfPairsOfCards: Int){
        for _ in 0..<numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection{
    var oneAndOnly: Element?{
        return count == 1 ? first : nil
    }
}
