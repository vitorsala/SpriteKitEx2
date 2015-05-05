//
//  GameScene.swift
//  SpriteKitEx2
//
//  Created by Vitor Kawai Sala on 04/05/15.
//  Copyright (c) 2015 Vitor Kawai Sala. All rights reserved.
//

import SpriteKit

struct CategoryNames {
    static let Ball = "ball"
    static let Paddle = "paddle"
    static let Block = "block"
    static let BlockNode = "blockNode"
    static let Bottom = "bottom"
}

struct CategoryMasks {
    static let None : UInt32    = 0x0
    static let All : UInt32     = 0x1 << 1
    static let Bottom : UInt32  = 0x1 << 2
    static let Ball : UInt32    = 0x1 << 3
    static let Paddle : UInt32  = 0x1 << 4
    static let Block : UInt32   = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var score = 0

    let numOfBlocks = 5

    override func didMoveToView(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsBody?.friction = 0

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zeroVector

        let paddle = childNodeWithName(CategoryNames.Paddle) as! SKSpriteNode
        paddle.physicsBody?.categoryBitMask = CategoryMasks.Paddle
        paddle.physicsBody?.collisionBitMask = CategoryMasks.Ball

        let ball = childNodeWithName(CategoryNames.Ball) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVector(dx: 10,dy: -10))
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.categoryBitMask = CategoryMasks.Ball
        ball.physicsBody?.collisionBitMask = CategoryMasks.Paddle | CategoryMasks.Bottom | CategoryMasks.Block
        ball.physicsBody?.contactTestBitMask = CategoryMasks.Bottom

        let bottom = childNodeWithName(CategoryNames.Bottom) as! SKSpriteNode
        bottom.physicsBody?.categoryBitMask = CategoryMasks.Bottom
        bottom.physicsBody?.collisionBitMask = CategoryMasks.Ball
        bottom.physicsBody?.contactTestBitMask = CategoryMasks.Ball

        addBlocks()

    }

    func addBlocks(){

        let blockWidth = SKSpriteNode(imageNamed: "block").size.width

        let totalBlocksWidth = blockWidth * CGFloat(numOfBlocks)

        let padding : CGFloat = 10
        let totalPadding = padding * CGFloat(numOfBlocks - 1)

        let xOffset = (CGRectGetWidth(frame) - totalBlocksWidth - totalPadding) / 2

        for i in 0 ..< numOfBlocks{

            let block = SKSpriteNode(imageNamed: "block")
            block.position = CGPointMake(xOffset + CGFloat(CGFloat(i) + 0.5)*blockWidth + CGFloat(i-1)*padding, CGRectGetHeight(frame) * 0.8)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
            block.physicsBody?.dynamic = false
            block.physicsBody?.allowsRotation = false
            block.physicsBody?.friction = 0
            block.physicsBody?.restitution = 1
            block.physicsBody?.categoryBitMask = CategoryMasks.Block
            block.physicsBody?.collisionBitMask = CategoryMasks.Ball
            block.physicsBody?.contactTestBitMask = CategoryMasks.Ball
            block.name = CategoryNames.Block

            addChild(block)

        }

    }

    override func update(currentTime: CFTimeInterval) {
        let ball = childNodeWithName(CategoryNames.Ball) as! SKSpriteNode

        let maxSpeed: CGFloat = 1000

        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)

        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        }
        else {
            ball.physicsBody!.linearDamping = 0.0
        }

    }

    func didBeginContact(contact: SKPhysicsContact) {
        var ba : SKPhysicsBody?
        var bb : SKPhysicsBody?
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            ba = contact.bodyA
            bb = contact.bodyB
        }
        else{
            ba = contact.bodyB
            bb = contact.bodyA
        }

        if(ba?.categoryBitMask == CategoryMasks.Bottom && bb?.categoryBitMask == CategoryMasks.Ball){
            let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as! GameOverScene
            gameOverScene.gameWon = false
            self.view?.presentScene(gameOverScene)
        }
        if(ba?.categoryBitMask == CategoryMasks.Ball && bb?.categoryBitMask == CategoryMasks.Block){
            score++
            bb?.node?.removeFromParent()
            if(score >= numOfBlocks){
                let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as! GameOverScene
                gameOverScene.gameWon = true
                self.view?.presentScene(gameOverScene)
            }
        }

    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchLocation = (touches.first as! UITouch).locationInNode(self)

        let paddle = childNodeWithName(CategoryNames.Paddle) as! SKSpriteNode

        var posx = touchLocation.x

        if (posx < paddle.size.width/2){
            posx = paddle.size.width/2
        }

        else if (posx > size.width-paddle.size.width/2){
            posx = size.width-paddle.size.width/2
        }

        let move = SKAction.moveToX(posx, duration: 0.1)
        paddle.runAction(move)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchLocation = (touches.first as! UITouch).locationInNode(self)

        let paddle = childNodeWithName(CategoryNames.Paddle) as! SKSpriteNode

        var posx = touchLocation.x

        if (posx < paddle.size.width/2){
            posx = paddle.size.width/2
        }

        else if (posx > size.width-paddle.size.width/2){
            posx = size.width-paddle.size.width/2
        }

        let move = SKAction.moveToX(posx, duration: 0.1)
        paddle.runAction(move)
    }
}
