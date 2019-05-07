//
//  ViewController.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-03-14.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cards: [CardView] = []
    lazy var grid = Grid(layout: .dimensions(rowCount: 4, columnCount: 3), frame: cardArea.bounds)
    private var game = SetGame()

    @IBOutlet weak var cardArea: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameFeedbackLabel: UILabel!
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
        refreshCards()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        for index in cards.indices{
            cards[index].removeFromSuperview()
        }
        cards.removeAll()
        game = SetGame()
        updateViewFromModel()
    }
    
    ///Selects a card when it is tapped, updating the model for the corresponding index and then updating the UI to show that selection.
    @objc func tappedCardView(recognizer: UITapGestureRecognizer){
        switch recognizer.state{
            case .changed: fallthrough
            case .ended:
                if let view = recognizer.view{
                    if let index = cards.firstIndex(of: view as! CardView){
                        game.selectCard(forIndex: index)
                        updateViewFromModel()
                    }
                }
            default: break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViewFromModel()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async() {
            //need these to update the frame of the cards when the view is rotated
            self.grid.frame = self.cardArea.bounds
            self.updateViewFromModel()
            self.refreshCards()
        }
    }
    
    /// Redraws the cards to display them correctly by calling setNeedsDisplay.
    /// This is needed to get the corners rounded correctly.
    private func refreshCards(){
        for card in self.cards{
            card.setNeedsDisplay()
        }
    }
    
    private func updateViewFromModel(){
        recalculateFramesForCardsOnTable()
        
        for index in game.cardsOnTable.indices{
            let card = game.cardsOnTable[index]
            
            updateCardViewFrames(withIndex: index)
            
            let cardView = cards[index]
            var cardString = ""
            for _ in 1...card.number{
                cardString += card.symbol.rawValue
            }
            //TODO: add/enable swipe gesture
            cardView.isUserInteractionEnabled = true
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
            var cardViewLabel: UILabel
            if cardView.subviews.isEmpty{
                cardViewLabel = UILabel(frame: cardView.bounds)
                cardViewLabel.textAlignment = .center
                cardView.addSubview(cardViewLabel)
            }else{
                cardViewLabel = cardView.subviews[0] as! UILabel
                cardViewLabel.frame = cardView.bounds
            }
            cardViewLabel.text = cardString
            cardViewLabel.attributedText = attributedCardString
            
            setBordersForCard(forCardView: cardView, withCardIndex: index)
            viewDidLayoutSubviews()
        }
        dealMoreCardsButton.isEnabled = game.cardsInDeck.count > 0
        setScoreLabel(withScore: game.score)
        updateGameFeedbackLabel()
    }
    
    /// Recalculates the frames for the cards that appear on the table.
    private func recalculateFramesForCardsOnTable(){
        let numberOfCardsOnTable = game.cardsOnTable.count
        var rows = 1 , columns = 1
        for multiple in 2...Int(sqrt(Double(numberOfCardsOnTable))){
            if numberOfCardsOnTable % Int(multiple) == 0{
                columns = multiple
                rows = numberOfCardsOnTable / multiple
            }
            grid.dimensions.rowCount = rows
            grid.dimensions.columnCount = columns
        }
    }
    
    private func updateCardViewFrames(withIndex index: Int){
        if let frame = grid[index]{//get the frame of the card
            if index<cards.count{ //check if the cardview exists already, rewrite the frame
                cards[index].frame = frame
            }else{ //if it doesn't exist, create the view and add it to the card area and array of cards
                let newCard = CardView(frame: frame)
                cards.append(newCard)
                cardArea.addSubview(newCard)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedCardView(recognizer:)))
                newCard.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    ///Sets border colours on the given CardView, depending if its index matches a selected card, matched card, mismatched card, or neither.
    private func setBordersForCard(forCardView cardView: CardView, withCardIndex cardIndex: Int){
        if game.selectedCardIndices.contains(cardIndex){
            cardView.layer.borderWidth = 3.0
            cardView.layer.borderColor = UIColor.blue.cgColor
            if game.matchedCardIndices.contains(cardIndex){
                cardView.isUserInteractionEnabled = false
                cardView.layer.borderColor = UIColor.green.cgColor
            }else if game.mismatchedCardIndices.contains(cardIndex){
                cardView.layer.borderColor = UIColor.red.cgColor
            }
        }else{ cardView.layer.borderWidth = 0 }
    }
    
    private func updateGameFeedbackLabel(){
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
}
