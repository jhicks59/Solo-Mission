//
//  GameViewController.swift
//  Solo Mission
//
//  Created by Jeremiah Hicks on 1/16/25.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backingAudio = AVAudioPlayer()
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "backingAudio", ofType:"mp3")
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
        
        do { backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL) }
        catch { return print("Cannot Find The Audio") }
        
        // This will make the audio loop forever
        backingAudio.numberOfLoops = -1
        backingAudio.volume = 1
        backingAudio.play()
        
           if let view = self.view as! SKView? {
               // Load the SKScene from 'GameScene.sks'
               let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
               // Set the scale mode to scale to fit the window
               scene.scaleMode = .aspectFill
                   
               // Present the scene
               view.presentScene(scene)
               
               view.ignoresSiblingOrder = true
               
               view.showsFPS = false
               view.showsNodeCount = false
           }

       }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
