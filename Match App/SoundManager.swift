//
//  SoundManager.swift
//  Match App
//
//  Created by Pablo Velez on 6/15/18.
//  Copyright © 2018 Pablo Velez. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager{
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect{
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    static func playSound(_ effect:SoundEffect){
        //determine which sound effect we want to play
        //set the appropriate filename
        var soundFilename = ""
        
        switch effect{
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
        
        }
        //get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else{
            print("Could not find sound file \(soundFilename) in the bundle")
            return
        }
        
        //create the URL object from the string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // creat audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //play the sound
            audioPlayer?.play()
        }
        catch {
            //couldn't create audio player obj
            print("Couldn't create the audio player obj for the sound file \(soundFilename)")
        }
    }
}
