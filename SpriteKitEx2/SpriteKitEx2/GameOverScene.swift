//
//  GameOverScene.swift
//  SpriteKitEx2
//
//  Created by Vitor Kawai Sala on 05/05/15.
//  Copyright (c) 2015 Vitor Kawai Sala. All rights reserved.
//

import SpriteKit

class GameOverScene : SKScene{
    let gameOverLabelCategory = "gameOverLabel"

    var gameWon : Bool = false{
        didSet{
            let gameOverLabel = (childNodeWithName(gameOverLabelCategory) as! SKLabelNode)
            gameOverLabel.text = gameWon ? "Game Won! 😆" : "Game Over! 😱"
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let view = view {
            let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
            view.presentScene(gameScene)
        }
    }
}
