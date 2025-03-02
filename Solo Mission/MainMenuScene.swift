//
//  MainMenuScene.swift
//  Solo Mission
//
//  Created by Jeremiah Hicks on 3/2/25.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // Game By: "Davaughn Williams'" Label
        let gameBy = SKLabelNode(fontNamed: "theBoldFont")
        gameBy.text = "XS Games Present"
        gameBy.fontSize = 50
        gameBy.fontColor = .white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.80)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        // Solo Label (Left Side of game title)
        let gameName1 = SKLabelNode(fontNamed: "theBoldFont")
        gameName1.text = "Solo"
        gameName1.fontSize = 200
        gameName1.fontColor = .white
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        // Mission Label (Right Side of game title)
        let gameName2 = SKLabelNode(fontNamed: "theBoldFont")
        gameName2.text = "Mission"
        gameName2.fontSize = 200
        gameName2.fontColor = .white
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        // Start Game Button/Label
        let startGame = SKLabelNode(fontNamed: "theBoldFont")
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = .white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            if nodeITapped.name == "startButton" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
}
