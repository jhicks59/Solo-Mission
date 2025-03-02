//
//  GameOverScene.swift
//  Solo Mission
//
//  Created by Jeremiah Hicks on 3/2/25.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let restartLabel = SKLabelNode(fontNamed: "theBoldFont")

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // Label Reading "Game Over"
        let gameOverLabel = SKLabelNode(fontNamed: "theBoldFont")
        gameOverLabel.text = "Game Over"
        // Original Code
        //        gameOverLabel.fontSize = 200
        //Changed Code due to size
        gameOverLabel.fontSize = 175
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition =  1
        self.addChild(gameOverLabel)
        
        // Label Reading "Player's Final Score"
        let scoreLabel = SKLabelNode(fontNamed: "theBoldFont")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        // High Score Logic to Save and Update the High Score everytime one is achieved
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        // Label Reading Player's "High Score"
        let highScoreLabel = SKLabelNode(fontNamed: "theBoldFont")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = .white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        // Restart Button Label
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = .white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
        // Makes our Restart Label a clickable button
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
}
