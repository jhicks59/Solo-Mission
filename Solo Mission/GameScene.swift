//
//  GameScene.swift
//  Solo Mission
//
//  Created by Jeremiah Hicks on 1/16/25.
//

import SpriteKit
import GameplayKit
// Declaring this variable outside of our GameScene allows us to use this variable to be available in other scenes
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Global variables and constant for it can be use in more than one area as well to improve perfomance.
    let scoreLabel = SKLabelNode(fontNamed: "theBoldFont")
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "theBoldFont")
    var levelNumber = 0
    let player = SKSpriteNode(imageNamed: "playerShip")
    let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSoundEffect.mp3", waitForCompletion: false)
    let tapToStartLabel = SKLabelNode(fontNamed: "theBoldFont")
    
    // Differene GameStates possible in our game
    enum gameState {
        case preGame // When the game state is before the start of the game
        case inGame // When the game state is during the game
        case afterGame // When the game state is after the game
    }
    
    var currentGameState = gameState.preGame
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 // 1 in Binary
        static let Bullet: UInt32 = 0b10 // 2 in Binary
        static let Enemy: UInt32 = 0b100 // 4 in Binary
    }
    // Randomized Function for enemy to spawn onto our scene
    func random() -> CGFloat {
//        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        // Updated Syntax
        return CGFloat.random(in: 0...1)
    }
    // Randomized the area in which a ship flies into the Scene
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    // Establishes our game area
    let gameArea: CGRect
    override init(size: CGSize) {
        // Original Code
//        let maxAspectRatio: CGFloat = 16.0/9.0
        // My customized code to help ship to fit on my iPhone 15 Pro
        let maxAspectRatio: CGFloat =  16.0/7.2
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Adding & Modifying Elements in the View
    override func didMove(to: SKView) {
        
        // The gameScore will only declare once since it's set outside of our GameScene, putting it here as well allows to redeclare our value and read it as 0.
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        // OG Background
//        let background = SKSpriteNode(imageNamed: "background")
//        background.size = self.size
//        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        background.zPosition = 0
//        self.addChild(background)

        
        // Scrolling Background
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        // Player
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // Gives our player a physic body
        player.physicsBody!.affectedByGravity = false // This makes sure our player's physic body isn't affected by gravity
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player // Assigns our player to a category
        player.physicsBody!.collisionBitMask = PhysicsCategories.None // This is tells the player's physic body to not collide with anything
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy // This tells our player what it can make contact with
        self.addChild(player)
        
        // Label for Score
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
//        scoreLabel.position = CGPoint(x: self.size.width*0.15 , y: self.size.height*0.9)
        // Updated code to move score to the right a bit more
        scoreLabel.position = CGPoint(x: self.size.width*0.22 , y: self.size.height + scoreLabel.frame.size.height)
        // The high number assures that your score label is on top of evertything and nothing is near it whatsoever
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        // Labels for Lives
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
//        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.9)
        // Updated code to move score to the left a bit more
        livesLabel.position = CGPoint(x: self.size.width*0.78, y: self.size.height + livesLabel.frame.size.height)
        // The high number assures that your score label is on top of evertything and nothing is near it whatsoever
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        // This is the origianl Y cordinates for our Score and Lives Labels
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        // Label for Begin Button
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = .white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        // Alpha relates to the transparancy of the object 0 is completely transparent and 1 full opacity
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        var lastUpdateTime: TimeInterval = 0
        var deltaFrameTime: TimeInterval = 0
        let amountToMovePerSecond: CGFloat = 600.0
        
        // Updates our Backgroud
        func update(currentTime: TimeInterval) {
            if lastUpdateTime == 0 {
                lastUpdateTime = currentTime
            } else {
                deltaFrameTime = currentTime - lastUpdateTime
                lastUpdateTime = currentTime
            }
            let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
            
            self.enumerateChildNodes(withName: "Background") { background, stop in
                if self.currentGameState == gameState.inGame {
                    background.position.y -= amountToMoveBackground
                }
                if background.position.y < -self.size.height {
                    background.position.y += self.size.height*2
                }
            }
        }
        
        
    }
    
    func startGame() {
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
    }
    
    // Lose a Life Function
    func loseALife() {
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
    }
    
    // Add Score Function
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            startNewLevel()
        }
    }
    
    // GameOver Function
    func runGameOver() {
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        // This cycles through a list of all bullets in our scene and commands it to stop
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    // DidBegin Function
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            // If the player has hit the enemy
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }

            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        // I added body2.node?.position.y and put it inside parentheses and added an exclamation point to force it to be unwrapped
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            addScore()
            
            // If the bullet has hit the enemy
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
    }
    
    // Spawns in the explosion graphics and effects
    func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    
    // Function to begin a new level
    func startNewLevel() {
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default: levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
        
    }
    
    // Bullet
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    
    // Enemy Spawn Function
    func spawnEnemy() {
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        
        // Enemy
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        if currentGameState == gameState.inGame {
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    // Func for when you tap your finger on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame {
            startGame()
        }
        // If this isn't an else if we will get a bullet firing the first time when we tap to begin the game
        else if currentGameState == .inGame {
            fireBullet()
        }
    }
    
    // Func for when you move your finger across the screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
            }
                
            // Original Code from "Matt Heaney Apps" Youtube Tutoral
//            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2 {
//                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
//            }
//            if player.position.x > CGRectGetMinX(gameArea) + player.size.width/2 {
//                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
//
//            }
            
            // Assures the spaceship can't move off of the screen
            // Fix Found in comments by "@afsanuddin4656"
            if player.position.x > gameArea.maxX - player.size.width/2 {
                player.position.x = gameArea.maxX - player.size.width/2
                }
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
                }
        }
    }
    
}
