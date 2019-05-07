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
    
    @IBOutlet weak var cardArea: UIView!
    lazy var grid = Grid(layout: .dimensions(rowCount: 4, columnCount: 3), frame: cardArea.bounds)
    
    var cards: [CardView] = []
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameFeedbackLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        for index in cards.indices{
            cards[index].removeFromSuperview()
        }
        cards.removeAll()
        game = SetGame()
        updateViewFromModel()
    }
    
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
        refreshCards()
    }
    
    ///Selects a card when it is tapped, updating the model for the corresponding index and then updating the UI to show that selection
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
        let numberOfCardsOnTable = game.cardsOnTable.count
        //update frames for cards
        var rows = 1 , columns = 1
        for multiple in 2...Int(sqrt(Double(numberOfCardsOnTable))){
            if numberOfCardsOnTable % Int(multiple) == 0{
                columns = multiple
                rows = numberOfCardsOnTable / multiple
            }
            
            grid.dimensions.rowCount = rows
            grid.dimensions.columnCount = columns
        }
        
        for index in game.cardsOnTable.indices{
            let card = game.cardsOnTable[index]
            
            //set the frame of the card
            if let frame = grid[index]{
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
            if cardView.subviews.isEmpty{
                let newLabel = UILabel(frame: cardView.bounds)
                newLabel.text = cardString
                newLabel.attributedText = attributedCardString
                newLabel.textAlignment = .center
                cardView.addSubview(newLabel)
            }else{
                let label = cardView.subviews[0] as! UILabel
                label.text = cardString
                label.attributedText = attributedCardString
                label.frame = cardView.bounds
            }
            
            //set border colours
            if game.selectedCardIndices.contains(index){
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = UIColor.blue.cgColor
                if game.matchedCardIndices.contains(index){
                    cardView.isUserInteractionEnabled = false
                    cardView.layer.borderColor = UIColor.green.cgColor
                }else if game.mismatchedCardIndices.contains(index){
                    cardView.layer.borderColor = UIColor.red.cgColor
                }
            }else{ cardView.layer.borderWidth = 0 }
            viewDidLayoutSubviews()
        }
        
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
}
