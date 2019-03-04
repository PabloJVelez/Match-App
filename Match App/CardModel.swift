//
//  CardModel.swift
//  Match App
//
//  Created by Pablo Velez on 6/14/18.
//  Copyright © 2018 Pablo Velez. All rights reserved.
//

import Foundation


class CardModel {
    
    func getCards() -> [Card] {
        
        //declare an array to store numbers we've already generated
        
        var generatedNumbersArray = [Int]()
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
    
        // Randomly generate pairs of cards
        
        while generatedNumbersArray.count < 8 {
            //get random number
            let randomNumber = arc4random_uniform(13) + 1
            
            
            //ensure that the number isnt one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
                
                //log the number
                print(randomNumber)
                
                //store the number into the generatedNumbersArray
                generatedNumbersArray.append(Int(randomNumber))
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                //create the second card object
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
                
                
            }
        
        
            //OPTIONAL: Make it so that we only have unique pairs of cards
        }

        //randomize the array
        
        for i in 0...generatedCardsArray.count-1{
            //find random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
        
        //swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        //return the array
        return generatedCardsArray
    }
    
}
