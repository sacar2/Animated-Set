//
//  ViewController.swift
//  2019-03-12_Assignment1-Concentration
//
//  Created by Selin Denise Acar on 2019-03-12.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // people can read this if they want, we dont care! setting it? sure I guess?
    var numberOfPairsOfCards: Int{
        return (cardButtons.count+1)/2
    }
    
    // this is our MODEL, it's tied to the UI through number of pairs of carsds, so set to private (only callable from this object)
    // concentration gets a free init because all it's variables were initialized! BUT, the numberOfCards initializer gets rid of that auto initializer
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        theme = setTheme()
        updateView()
    }
    
    override func viewDidLoad() {
        updateView()
    }
    
    private func updateView(){
        view.backgroundColor = theme.backgroundColour
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    private func updateScoreLabel(withScore score: Int){
        scoreLabel.text = "score: \(score)"
    }
    
    private func updateFlipCountLabel(withFlipCount flipCount: Int){
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : theme.cardColor
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!{
        //gets called when this outlet gets set by iOS!
        didSet{
            updateFlipCountLabel(withFlipCount: 0)
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    //this allows you to choose the theme
    lazy private var theme = setTheme()
    
    private func setTheme() -> Theme{
        return themes[4]
    }
    
    //would it be better for this to be in here or in the Concentration class?
    private var themes =
        [
        Theme(name: "smileys",
              backgroundColour: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
              cardColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
              emojis: "😀😁😂😃😄😅😆😇😈👿😉😊☺️😋"),
        Theme(name: "moonPhases",
              backgroundColour: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),
              cardColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
              emojis: "🌑🌒🌓🌔🌕🌖🌗🌘🌚🌝🌛🌜"),
        Theme(name: "time",
              backgroundColour: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
              cardColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
              emojis: "🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚🕛🕜🕝🕞🕟🕠🕡🕢🕣🕤🕥🕦🕧"),
        Theme(name: "handSigns",
              backgroundColour: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),
              cardColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
              emojis: "👋👋🏿👍👍🏽👎🏼👎🏿☝🏻☝🏾👆🏻👇👇🏾👈🏾👈🏿👉👉🏻👌🏽👌🏿✌🏻✌🏽👊👊🏽✊🏼✊🏿✋🏾✋🏿"),
        Theme(name: "sports",
              backgroundColour: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
              cardColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
              emojis: "🏃🏽💃🏿🚣🏾🏊🏾🏄🏿🏂🎿🚴🏻🚴🏾🚵🏼🏇🏻🎣⚽️🏀🏈⚾️🎾🏉⛳️🏆🎽🏁"),
        Theme(name: "halloween",
              backgroundColour: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
              cardColor: #colorLiteral(red: 1, green: 0.51845783, blue: 0.05705033988, alpha: 1),
              emojis: "👻🎃👽👺💀👯🔮👸🏻🎅🏾👼🏻👷🏽👮👵🏼🍬🍫🐭🐰"),
        Theme(name: "horoscopes",
              backgroundColour: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
              cardColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),
              emojis: "♈️♉️♊️♋️♌️♍️♎️♏️♐️♑️♒️♓️")
        ]
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("button clicked is not part of the concentration game deck")
        }
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(getEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
        updateScoreLabel(withScore: game.score)
        updateFlipCountLabel(withFlipCount: game.flipCount)
    }
    
    private var emoji = Dictionary<Card, String>()
    
    private func getEmoji(for card: Card) -> String{
        if emoji[card] == nil{
            let randomStringIndex = theme.emojis.index(theme.emojis.startIndex, offsetBy: theme.emojis.count.arc4random)
            emoji[card] = String(theme.emojis.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int{
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return Int(arc4random_uniform(UInt32(-self)))
        } else{
            return 0
        }
    }
}

