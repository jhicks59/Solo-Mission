//
//  GameSceneModel.swift
//  Solo Mission
//
//  Created by Jeremiah Hicks on 3/2/25.
//

import Foundation
import SpriteKit

let scoreLabel = SKLabelNode(fontNamed: "theBoldFont")
var livesNumber = 3
let livesLabel = SKLabelNode(fontNamed: "theBoldFont")
var levelNumber = 0
let player = SKSpriteNode(imageNamed: "playerShip")
let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect.wav", waitForCompletion: false)
let explosionSound = SKAction.playSoundFileNamed("explosionSoundEffect.mp3", waitForCompletion: false)
let tapToStartLabel = SKLabelNode(fontNamed: "theBoldFont")
