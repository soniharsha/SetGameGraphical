//
//  ViewController.swift
//  Concentration
//
//  Created by Harsha on 06/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {    
    private var game: Concentration!
    
    private var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var gameControlLabel: UIButton!
    
    // Actions
    
    @IBAction func gameControl(_ sender: UIButton) {
        let title = gameControlLabel.title(for: UIControl.State.normal)!
        if title == "Start" {
            updateStopView()
        } else {
            updateStartView()
        }
    }
    
    private func updateStopView() {
        //gameControlLabel.backgroundColor = buttonBackgroundColor
        //buttonBackgroundColor = UIColor(red: 193/255, green: 172/255, blue: 230/255, alpha: 1)
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        flipCountLabel.text = "SCORE: \(game.score)"
        gameControlLabel.setTitle("Stop", for: UIControl.State.normal)
        assignEmojiToCards()
        flipCountLabel.textColor = UIColor.white
        flipCountLabel.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        gameControlLabel.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    private func updateStartView() {
        gameControlBackgroundColor = UIColor(red: 35/255, green: 65/255, blue: 66/255, alpha: 1)
        buttonBackgroundColor = UIColor(red: 193/255, green: 172/255, blue: 230/255, alpha: 1)
        gameControlLabel.setTitle("Start", for: UIControl.State.normal)
        for index in cardButtons.indices { // use forEach
            let button = cardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = buttonBackgroundColor
            emoji[game.cards[index].identifier] = nil
        }
        game.reset()
        flipCountLabel.textColor = defaultCountLabelColor
        flipCountLabel.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.view.backgroundColor = defaultViewColor
        gameControlLabel.backgroundColor = gameControlBackgroundColor
        gameControlLabel.setTitleColor(defaultCountLabelColor, for: UIControl.State.normal)
        flipCountLabel.text = "SCORE: \(game.score)"
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender), gameControlLabel.title(for: UIControl.State.normal) == "Stop" /* unwraps optional value and if set then 'if' is executed otherwsie 'else' will be executed*/{
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    // Make things private
     
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? UIColor.white.withAlphaComponent(0.0) : buttonBackgroundColor
            }
        }
        flipCountLabel.text = "SCORE: \(game.score)"
    }
    
    private var emoji = [Int:String]()
    private var defaultCountLabelColor = UIColor(red: 77/255, green: 141/255, blue: 176/255, alpha: 1)
    private var defaultViewColor = UIColor(red: 111/255, green: 96/255, blue: 128/255, alpha: 1)
    private var gameControlBackgroundColor = UIColor(red: 35/255, green: 65/255, blue: 66/255, alpha: 1)
    private var buttonBackgroundColor = UIColor(red: 193/255, green: 172/255, blue: 230/255, alpha: 1)
    
    private func emoji(for card: Card) -> String? {
        //used in case of "optional datatype" so if it's set it's unwrapped and returned or else different value is returned in this case "?"
        return emoji[card.identifier]
    }
    
    
    private func assignEmojiToCards() {
        var emojiChoices = [0: ["🤣","😍","🤫","🤮","🤦🏻‍♀️","🤷🏻‍♀️","🥺","🙆🏻‍♀️"],
                            1: ["🙈","🙉","🙊","🐵","🐒","🐻","🐨","🐶"],
                            2: ["🍐","🍏","🍈","🍌","🥝","🍋","🍇","🍍"],
                            3: ["❤️","🧡","💛","💚","💙","💜","💖","🖤"]]
        
        var viewBackgroundColors = [UIColor(red: 194/255, green: 180/255, blue: 77/255, alpha: 1), UIColor(red: 118/255, green: 131/255, blue: 106/255, alpha: 1), UIColor(red: 178/255, green: 194/255, blue: 141/255, alpha: 1), UIColor(red: 128/255, green: 13/255, blue: 8/255, alpha: 1) ]
        var buttonBackgroundColors = [UIColor(red: 188/255, green: 230/255, blue: 131/255, alpha: 1), UIColor(red: 66/255, green: 61/255, blue: 11/255, alpha: 1), UIColor(red: 126/255, green: 138/255, blue: 69/255, alpha: 1), UIColor(red: 112/255, green: 108/255, blue: 104/255, alpha: 1)]
        var gameControlBackgroundColors = [UIColor(red: 128/255, green: 125/255, blue: 46/255, alpha: 1), UIColor(red: 138/255, green: 124/255, blue: 69/255, alpha: 1), UIColor(red: 27/255, green: 66/255, blue: 14/255, alpha: 1), UIColor(red: 179/255, green: 75/255, blue: 70/255, alpha: 1)]
        
        var uniqueEmojiIndex = 0
        let totalUniqueEmojiIndex = numberOfPairsOfCards
        let randomKey = (emojiChoices.count).random4arc
        self.view.backgroundColor = viewBackgroundColors[randomKey]
        buttonBackgroundColor = buttonBackgroundColors[randomKey]
        gameControlBackgroundColor = gameControlBackgroundColors[randomKey]
        gameControlLabel.backgroundColor = gameControlBackgroundColor
        
        for index in cardButtons.indices {
            let card = game.cards[index]
            cardButtons[index].backgroundColor = buttonBackgroundColor
            if emoji[card.identifier] == nil {
                let randomEmojiIndex = (totalUniqueEmojiIndex-uniqueEmojiIndex).random4arc
                emoji[card.identifier] = emojiChoices[randomKey]![randomEmojiIndex]
                emojiChoices[randomKey]!.remove(at: randomEmojiIndex)
                uniqueEmojiIndex = uniqueEmojiIndex + 1
            }
        }
    }
}
