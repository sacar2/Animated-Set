//
//  ViewController.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-03-14.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameFeedbackLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        for index in cardButtons.indices{
            restartButton(cardButtons[index])
        }
        updateViewFromModel()
    }
    
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    
    @IBAction func tappedCardButton(_ sender: UIButton) {
        if let buttonIndex = cardButtons.index(of: sender){
            game.selectCard(forIndex: buttonIndex)
            updateViewFromModel()
        }
    }
    
    override func viewDidLoad() {
        for card in cardButtons{
            card.layer.backgroundColor = UIColor.clear.cgColor
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        for index in game.cardsOnTable.indices{
            let card = game.cardsOnTable[index]
            let cardButton = cardButtons[index]
            var cardString = ""
            for _ in 1...card.number{
                cardString += card.symbol.rawValue
            }
            
            if card.color == UIColor.clear{
                restartButton(cardButton)
            }else{
                cardButton.layer.backgroundColor = UIColor.lightGray.cgColor
                cardButton.isEnabled = true
                var attributes: [NSAttributedString.Key: Any] = [:]
                if card.shading == SetCard.Shading.open{
                    attributes = [
                        NSAttributedString.Key.strokeWidth: 5,
                        NSAttributedString.Key.strokeColor: card.color
                    ]
                } else if card.shading == SetCard.Shading.solid{
                    attributes = [
                        NSAttributedString.Key.strokeWidth: -1,
                        NSAttributedString.Key.foregroundColor: card.color
                    ]
                } else if card.shading == SetCard.Shading.striped{
                    attributes = [
                        NSAttributedString.Key.strokeWidth: -1,
                        NSAttributedString.Key.strokeColor: card.color,
                        NSAttributedString.Key.foregroundColor: card.color.withAlphaComponent(0.15)
                    ]
                }
                let attributedCardString = NSAttributedString(string: cardString, attributes: attributes)

                cardButton.setTitle(cardString, for: UIControl.State.normal)
                cardButton.setAttributedTitle(attributedCardString, for: UIControl.State.normal)
            }
            
            if game.selectedCardIndices.contains(index){
                cardButton.layer.borderWidth = 3.0
                cardButton.layer.borderColor = UIColor.blue.cgColor
                if game.matchedCardIndices.contains(index){
                    cardButton.layer.borderColor = UIColor.green.cgColor
                    cardButton.isEnabled = false  //makesure that the matched cards cannot be deselected
                }else if game.mismatchedCardIndices.contains(index){
                    cardButton.layer.borderColor = UIColor.red.cgColor
                }
            }else{ cardButton.layer.borderWidth = 0 }
        }
        
        //if there's no space on the table or no cards in the deck
        dealMoreCardsButton.isEnabled = game.cardsInDeck.count > 0
        
        setScoreLabel(withScore: game.score)
        if !game.matchedCardIndices.isEmpty{
            gameFeedbackLabel.text = "You found a set 😁"
        }else if !game.mismatchedCardIndices.isEmpty{
            gameFeedbackLabel.text = "This is not a matching set 😣"
        }else{
            gameFeedbackLabel.text = "Tap three cards to make a set!"
        }
    }

    private func setScoreLabel(withScore score: Int){
        scoreLabel.text = "Score: \(score)"
    }
    
    private func restartButton(_ button: UIButton){
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.isEnabled = false
        button.setTitle("", for: UIControl.State.normal)
        button.setAttributedTitle(NSAttributedString(), for: UIControl.State.normal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 0.0
    }
}
