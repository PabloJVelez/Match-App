//
//  ViewController.swift
//  Match App
//
//  Created by Pablo Velez on 6/14/18.
//  Copyright © 2018 Pablo Velez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 10*1000 //10 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //create timer
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        RunLoop.main.add(timer!, forMode: .commonModes)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        // set cell size
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let width = self.collectionView.frame.size.width
        let itemWidth = (width - (10*3))/4
        let itemHeight = itemWidth * 1.4177
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        
        
        //play shuffle sound
        SoundManager.playSound(.shuffle)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Timer Methods
    
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        //express in seconds
       let seconds = String(format: "%.2f", milliseconds/1000)
        
        //set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //when the timer reaches zero...stop it
        
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocol Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        //Get a CardCollectionViewCell obj
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Get the card that collection view is trying to display
        let card = cardArray[indexPath.row]
        
        //Set that card for the call
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //check if there is any time left
        if milliseconds <= 0 {
            return
        }
        //get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            // Flip the card
            cell.flip()
            
            //play the flip sound
            
            SoundManager.playSound(.flip)
            
            //set the status of card
            card.isFlipped = true
            
            
            //Determine if its the first or second card that has been flipped over
            
            if firstFlippedCardIndex == nil{
                
                firstFlippedCardIndex = indexPath
                
            }
            else{
                //this is the second card that was flipped
                
                //Perform the matching logic
                
                checkForMatches(indexPath)
            }
        }
        }//end the didselectitemat method
        
        // MARK: - Game Logic Methods
        
        func checkForMatches(_ secondFlippedCardIndex:IndexPath){
            
            //get the cells for the two cards that were revealed
            let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
            
            let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
            
            //get the cards for the two cards that were revealed
            
            let cardOne = cardArray[firstFlippedCardIndex!.row]
            let cardTwo = cardArray[secondFlippedCardIndex.row]
            
            //compare the two cards
            
            if cardOne.imageName == cardTwo.imageName {
                //its a match
                
                
                //play sound
                SoundManager.playSound(.match)
                
                //set the status of the cards
                cardOne.isMatched = true
                cardTwo.isMatched = true
                
                
                //remove the cards from the grid
                cardOneCell?.remove()
                cardTwoCell?.remove()
                
            }
            else {
                //its not a match
                
                //play sound
                SoundManager.playSound(.nomatch)
                //set the status of the cards
                cardOne.isFlipped  = false
                cardTwo.isFlipped  = false
                
                //flip both cards back
                cardOneCell?.flipBack()
                cardTwoCell?.flipBack()
                
                //check if any cards are left unmatched
            }
            //tell the collection view to reload the cell of the first card if it is nil
            
            if cardOneCell == nil {
                collectionView.reloadItems(at: [firstFlippedCardIndex!])
            }
            //reset the property that tracks the first card flipped
            firstFlippedCardIndex = nil
        }
    
    func checkGameEnded(){
        
        //determine if there are any cards unmatched
        
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        //messaging variables
        var title = " "
        var message = " "
        
        //if not, user has won...stop timer
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've won"
        }
        else{
        //if there is check if there is any time left
            if milliseconds > 0{
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        //show won/lost message
       showAlert(title, message)
        
    }
    
    
    func showAlert(_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
 //end of viewcontroller class

