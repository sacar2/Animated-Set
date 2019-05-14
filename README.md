# Annimated-Set
The game of set implemented using custom drawing with bezier paths, and animations. This also includes the previously created Concentration Game.

## What is Set?
Goal of the game is to find sets among the cards on the table to remove as many cards from the table as possible.

There are four characteristics on a card: colour (red, blue, green), symbol(square, triangle, circle), number (1, 2, 3), and shadig (solid, shaded, or outlined). 
A set consists of three cards which either present all or the same of each of the different characteristics. This means that the three selected cards have either all of the same colour or all different colours,  all of the same symbol or all different symbols,  all of the same number of symbols or all different number of symbols,  all of the same shading or all different shading.

## How to play
Tap on cards to select. Tap a selected card to deselected it.
New game button restarts the game. 
Deal cards button deals three cards form the deck, adding them to the cards on the table.

Matching sets will not be removed from the table until antoher card is selected, or the *deal cards* button is tapped. Both methods will replace the the matching set with three cards from the deck in its place. In the case that there are no more cards in the deck, the cards will disappear.

The cards on the table adjust their sizes to fit within the space avaialble on the table. The more cards there are on the table, the smaller the cards, and vice versa. 

Selected cards are highlighted with a light grey outline.
Matching cards are indicated by a green highlight border around the card.
Mismatched cards are indicated by a red highlight border around the card.

### Gestures
__Swipe down__: Deals three cards.

__Rotation Gesture__: Shuffles the cards on the table.

### Scoring and Points
Score starts at zero and can go into the negative.

Each matched set earns points. The more cards on the table, the less points can be earned from a matched set.

Each mismatched set (three selected cards that do not create a set), will decrease points. the more Cards on the table, the more points will be decreased as it should be easier to come up with a set the more card options are available.

Each deselected card will remove a point.

---

### Features & Concepts Used:
- A custom UIView with a draw(CGRect) method
- Gestures (swipe, rotation)
- Creating UIViews in programatically
- Drawing with Core Graphics and UIBezierPath
- UIViewPropertyAnimator
- UIDynamicAnimator
- Timer
- UIView.transition(with:duration:options:animations:completion:)
- UINavigationController, UISplitViewController, and UITabBarController
- Segues
- Autolayout
