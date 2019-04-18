//
//  SetGame.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-03-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class SetGame{
    
    private(set) var score = 0
    private(set) var cardsInDeck = [SetCard]()
    private(set) var cardsOnTable = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var selectedCardIndices = [Int]()
    private(set) var matchedCardIndices = [Int]()
    private(set) var mismatchedCardIndices = [Int]()
    private var setsOf3Cards = 0
    
    init(){
        createDeck()
        for _ in 1...4{ deal3Cards() }
    }
    
    private func createDeck(){
        for symbol in SetCard.Symbol.allCases{
            for shade in SetCard.Shading.allCases{
                for number in 1...3{
                    for color in [UIColor.red, UIColor.blue, UIColor.yellow]{
                        cardsInDeck.append(SetCard(withSymbol: symbol, withNumberOfSymbols: number, hasShading: shade, withColor: color))
                    }
                }
            }
        }
        cardsInDeck.shuffle()
    }
    
    //only deal cards if there's space on the table
    func deal3Cards(){
        if matchedCardIndices.isEmpty{
            for _ in 1...3{
                if cardsOnTable.count < 24, let randomCard = cardsInDeck.popLast(){
                    cardsOnTable.append(randomCard)
                }
            }
            setsOf3Cards += 1
        }else{
            removeMatchedCards()
        }
        if isThereAnAvailableSetOnTheTable() == true{
            //TODO: Negate points
        }
    }
    
    func isThereAnAvailableSetOnTheTable() -> Bool{
        //An algorithm to tell if there is an available set
        //TODO: what is an efficient way to go through the cards on the table and call verifySet(forCardIndices:)
        
        return false
    }

    
    func selectCard(forIndex index: Int){
        //assert that the cards on the table contains that index (if it doesn't then something else is screwed up, so crash!
        assert (cardsOnTable.indices.contains(index), "card tapped is out of bounds of playable cards")
        removeMatchedCards()
        
        if !mismatchedCardIndices.isEmpty{
            flipIsMismatchForMismatches()
            mismatchedCardIndices.removeAll()
        }
        
        //if card is already selected, unselect the card
        if let indexOfSelectedCard = selectedCardIndices.index(of: index){
            selectedCardIndices.remove(at: indexOfSelectedCard)
            reduceScoreDueToDeselection()
        }else{//if the card is not already selected
            //check if there are 3 cards already selected, and if so, unselect them
            if selectedCardIndices.count == 3{
                selectedCardIndices.removeAll()
            }
            selectedCardIndices.append(index)
            //if adding the new card equals 3, check if its a set
            if selectedCardIndices.count == 3{
                verifySet(forCardIndices: selectedCardIndices)
            }
        }
    }
    
    func removeMatchedCards(){
        //during the next selection or tap to the "add 3 more cards" button, manage the 3 matched cards , replace the cards with 3 from the deck
        for matchIndex in matchedCardIndices{
            if cardsInDeck.count > 0{
                cardsOnTable[matchIndex] = cardsInDeck.removeLast()
            }else{ //if there are no more items in the deck, make that card invisible
                cardsOnTable[matchIndex].color = UIColor.clear
            }
            if let selectedCardIndex = selectedCardIndices.index(of: matchIndex){
                selectedCardIndices.remove(at: selectedCardIndex)
            }
        }
        
        //reset the matched card indices to an empty array
        matchedCardIndices.removeAll()
    }
    
    //check if they are all equal or all different for each property. as soon as one is false, return and do nothing
    func verifySet(forCardIndices indices: [Int]){
        //had to template the equatable type: call function with type T, where T is a template for all equatable types
        func checkIfAllEqualForValues<T: Equatable>(_ values: [T]) -> Bool{
            return (values[0] == values[1] && values[1] == values[2])
        }
        
        func checkIfAllDifferentForValues<T: Equatable>(_ values: [T]) -> Bool{
            return values[0] != values[1] && values[1] != values[2] && values[0] != values[2]
        }
        
        //only doing multiple if statements instead of one large one because it's easier to read
        //cards must all be the same colour or all different colours
        if checkIfAllEqualForValues([cardsOnTable[indices[0]].color, cardsOnTable[indices[1]].color, cardsOnTable[indices[2]].color]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].color, cardsOnTable[indices[1]].color, cardsOnTable[indices[2]].color]){
            //cards must all be the same number or all different numbers
            if checkIfAllEqualForValues([cardsOnTable[indices[0]].number, cardsOnTable[indices[1]].number, cardsOnTable[indices[2]].number]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].number, cardsOnTable[indices[1]].number, cardsOnTable[indices[2]].number]){
                //cards must all be the same shading or all different shades
                if checkIfAllEqualForValues([cardsOnTable[indices[0]].shading, cardsOnTable[indices[1]].shading, cardsOnTable[indices[2]].shading]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].shading, cardsOnTable[indices[1]].shading, cardsOnTable[indices[2]].shading]){
                    //cards must all be the same symbol or all different symbols
                    if checkIfAllEqualForValues([cardsOnTable[indices[0]].symbol, cardsOnTable[indices[1]].symbol, cardsOnTable[indices[2]].symbol]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].symbol, cardsOnTable[indices[1]].symbol, cardsOnTable[indices[2]].symbol]){
                        //If you make it here then yeah they're a set! wooooo.
                        
                        //now add it to your matched cards (next time something is highlighted, check if it's matched, if it is then remove it from the cards on the table and replace these matched cards with 3 from the deck)
                        for matchIndex in indices{
                            cardsOnTable[matchIndex].isMatched = true
                            matchedCards.append(cardsOnTable[matchIndex])
                        }
                        //add card indices to matched card indices so that during the next selection or tap to the "add 3 more cards" button, the 3 matched cards can be handled
                        matchedCardIndices = indices
                        increaseScoreDueToMatch()
                    }else{
                        handleMismatch(forIndices: indices)
                    }
                }else{
                    handleMismatch(forIndices: indices)
                }
            }else{
                handleMismatch(forIndices: indices)
            }
        }else{
            handleMismatch(forIndices: indices)
        }
    }
    
    private func reduceScoreDueToDeselection(){
        score -= 1
    }
    
    private func handleMismatch(forIndices indices: [Int]){
        mismatchedCardIndices = indices
        reduceScoreDueToMismatch()
        flipIsMismatchForMismatches()
    }
    
    private func flipIsMismatchForMismatches(){
        for index in mismatchedCardIndices{
            cardsOnTable[index].isMismatched = !cardsOnTable[index].isMismatched
        }
    }
    
    private func reduceScoreDueToMismatch(){
        score -= setsOf3Cards //if there are more cards on the table, reduce score more
    }
    
    private func increaseScoreDueToMatch(){
        score += (11 - setsOf3Cards) //if there are more cards on the table, reduce additional score. max sets is 8
    }
}



