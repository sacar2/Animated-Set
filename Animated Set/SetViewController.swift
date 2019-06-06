//
//  ViewController.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-03-14.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    let aspectRatio:  CGFloat = 1.5
    var cards: [CardView] = []
    lazy var grid = Grid(layout: .aspectRatio(aspectRatio), frame: cardArea.bounds)
    private var game = SetGame()

    @IBOutlet weak var cardArea: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameFeedbackLabel: UILabel!
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var playingAreaStackView: UIStackView!
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        dealCards()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        endLastGame()
        startNewGame()
    }
    
    private func startNewGame(){
        game = SetGame()
        game.delegate = self
        updateViewFromModel()
    }
    
    private func endLastGame(){
        for index in cards.indices{
            cards[index].removeFromSuperview()
        }
        cards.removeAll()
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
    
    override func viewDidLoad() {
        game.delegate = self
        setupSwipeDownGesture()
        setupRotationGesture()
        setViewContraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViewFromModel()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async() {
            //need these to update the frame of the cards when the view is rotated
            self.setViewContraints()
            self.grid.frame = self.cardArea.bounds
            self.updateViewFromModel()
            self.refreshCards()
        }
    }
    
    private func setViewContraints(){
        if tabBarController?.selectedViewController == self{
            let deviceOrientation = UIApplication.shared.statusBarOrientation
            if  deviceOrientation == UIInterfaceOrientation.landscapeLeft || deviceOrientation == UIInterfaceOrientation.landscapeRight{
                self.playingAreaStackView.axis = NSLayoutConstraint.Axis.horizontal
                self.actionStackView.axis = NSLayoutConstraint.Axis.vertical
            }else if deviceOrientation == UIInterfaceOrientation.portrait || deviceOrientation == UIInterfaceOrientation.portraitUpsideDown{
                self.playingAreaStackView.axis = NSLayoutConstraint.Axis.vertical
                self.actionStackView.axis = NSLayoutConstraint.Axis.horizontal
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dealCards(){
        game.deal3Cards()
        updateViewFromModel()
        refreshCards()
    }
    
    private func setupSwipeDownGesture(){
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SetViewController.dealCards))
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    private func setupRotationGesture(){
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(SetViewController.shuffleCardsOnTable))
        view.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    @objc private func shuffleCardsOnTable(){
        game.shuffleCardsOnTable()
        updateViewFromModel()
    }
    
    private func updateCardLabels(){
        for index in cards.indices{
            let cardView = cards[index]
            if let cardLabel = (cardView.subviews.first as? CardLabel){
                cardLabel.updateCardAttributes(withSymbol: game.cardsOnTable[index].symbol, color: game.cardsOnTable[index].color, numberOfShapes: game.cardsOnTable[index].number, shading: game.cardsOnTable[index].shading)
                cardLabel.setNeedsDisplay()
            }
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
            cardView.isUserInteractionEnabled = true
            
            var cardViewLabel: CardLabel
            if cardView.subviews.isEmpty{
                cardViewLabel = CardLabel(frame: cardView.bounds, symbol: card.symbol, color: card.color, numberOfShapes: card.number, shading: card.shading)
                cardView.addSubview(cardViewLabel)
            }else{
                cardViewLabel = cardView.subviews[0] as! CardLabel
                cardViewLabel.frame = cardView.bounds
                updateCardLabels()
            }
            setBordersForCard(forCardView: cardView, withCardIndex: index)
            viewDidLayoutSubviews()
        }
//        dealMoreCardsButton.isEnabled = game.cardsInDeck.count > 0
        setScoreLabel(withScore: game.score)
        updateGameFeedbackLabel()
    }
    
    /// Recalculates the frames for the cards that appear on the table.
    private func recalculateFramesForCardsOnTable(){
        let numberOfCardsOnTable = game.cardsOnTable.count
        grid.cellCount = numberOfCardsOnTable
    }
    
    private func updateCardViewFrames(withIndex index: Int){
        if let frame = grid[index]{//get the frame of the card
            if index<cards.count{ //check if the cardview exists already, rewrite the frame
                cards[index].frame = frame
            }else{ //if it doesn't exist, create the view and add it to the card area and array of cards
                let newCard = CardView(frame: frame)
                cards.append(newCard)
                cardArea.addSubview(newCard)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SetViewController.tappedCardView(recognizer:)))
                newCard.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    ///Sets border colours on the given CardView, depending if its index matches a selected card, matched card, mismatched card, or neither.
    private func setBordersForCard(forCardView cardView: CardView, withCardIndex cardIndex: Int){
        if game.selectedCardIndices.contains(cardIndex){
            cardView.layer.borderWidth = 3.0
            cardView.layer.cornerRadius = 15.0
            cardView.layer.borderColor = UIColor.lightGray.cgColor
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

extension SetViewController: SetGameDelegate{
    func removeCardsFromView(forCardIndices indices: [Int]) {
        for index in indices.sorted(by: >){
            cards[index].removeFromSuperview()
            cards.remove(at: index)
        }
    }
}
