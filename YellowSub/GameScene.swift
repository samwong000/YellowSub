//
//  GameScene.swift
//  YellowSub
//
//  Created by Sam Wong on 14/01/2015.
//  Copyright (c) 2015 sam wong. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Constants and Variables
    
    var viewController:GameViewController?
    
    //Game Variables
//    var colorBackground:SKColor! = SKColor(red: 14/255, green: 98/255, blue: 190/255, alpha: 1.0)
    var colorBackground:SKColor! = SKColor(red: 12/255, green: 77/255, blue: 105/255, alpha: 1.0)
    var start:Bool = false
    
    let categoryHero:UInt32   = 0x1 << 0
    let categoryEnemy:UInt32    = 0x1 << 1
    let categoryScreen:UInt32   = 0x1 << 2
    
    let linearDamping:CGFloat = 0.65
    let angularDamping:CGFloat = 1.0
    var gravityX:CGFloat = 6.0
    let impulseY:CGFloat = 2.0 //4.0
    let impulseX:CGFloat = 5.0 //10.0
    var lastYposition:CGFloat = 300.0
    let ditanceBetweenBars:CGFloat = 175.0
    let ditanceFromBarToBar:CGFloat = 300.0
    
    let horizontalGravity: CGFloat = 0.0
    let verticalGravity: CGFloat = 0.4
    
    //Nodes
    //SKSCENE
    let nodePoints = SKLabelNode()
    let nodeJellyfish = SKNode()
    let nodeWorld = SKNode()
    let nodeEnemies = SKNode()
    var nodeHero = SKNode()
    var spriteHero:SKSpriteNode!
    
    //Bubble scene
    var bubbleEmitter = SKEmitterNode()
    
    //Footer scene
    var nodeFooter = SKEmitterNode()
    
    // MARK: - Initialisation
    
    //Init
    override func didMoveToView(view: SKView) {
        self.startWorld()
        self.initBubbleEmitter()
        self.initPhysics()
        self.initFooter()
        self.startHero()
        self.startJellyfish()
        self.startEnemies()
        nodeWorld.addChild(nodeEnemies)
        
        view.showsPhysics = true
    }
    
    func initBubbleEmitter() {
        self.bubbleEmitter = SKEmitterNode(fileNamed: "SodaBubbles.sks")
        self.bubbleEmitter.name = "bubbleEmitter"
        self.bubbleEmitter.particlePositionRange = CGVectorMake(CGRectGetWidth(self.view!.frame), 0.0)
        self.bubbleEmitter.position = CGPointMake(0, -250.0)
        
        self.insertChild(bubbleEmitter, atIndex: 0)
       // self.addChild(self.bubbleEmitter)
    }
    
    func initPhysics() {
        self.physicsWorld.contactDelegate = self
        
//        self.physicsWorld.gravity = CGVectorMake(self.horizontalGravity, self.verticalGravity)
        self.physicsWorld.gravity = CGVectorMake(gravityX, 0.0)
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.categoryBitMask = categoryScreen
        nodeWorld.physicsBody = borderBody
    }
    
    func startWorld() {
        self.backgroundColor = colorBackground
        self.anchorPoint = CGPointMake(0.5,0.5)
        self.addChild(nodeWorld)
        
        nodePoints.fontName = "Lobster 1.4"
        nodePoints.text = "0123456789"
        nodePoints.text = "0"
        nodePoints.fontSize = 48
        nodePoints.fontColor = SKColor.whiteColor()
        nodePoints.position = CGPointMake(0, self.frame.size.height*0.33)
        nodePoints.zPosition = 100;
        self.addChild(nodePoints)
    }
    
    func initFooter() {
        let spriteGround = SKSpriteNode(imageNamed: "coralfooter")
        spriteGround.zPosition = 1
        spriteGround.size = CGSizeMake(spriteGround.size.width/2, spriteGround.size.height/4)
        spriteGround.position = CGPointMake(0, -50)
        nodeWorld.addChild(spriteGround)
    }
    
    //Create Diver
    func startHero() {
        nodeHero.position = CGPointMake(0,0)
        nodeHero.zPosition = 10
        
        spriteHero = SKSpriteNode(imageNamed: "diver")
        spriteHero.size = CGSizeMake(spriteHero.size.width/3, spriteHero.size.height/3)
        spriteHero.position = CGPointMake(0,0)
        
        nodeHero.addChild(spriteHero)
        nodeWorld.addChild(nodeHero)
        
        let nodeBody = SKPhysicsBody(circleOfRadius: 0.9*spriteHero.frame.size.width/4)
        nodeBody.linearDamping = linearDamping
        nodeBody.angularDamping = angularDamping
        nodeBody.allowsRotation = true
        nodeBody.affectedByGravity = false
        nodeBody.categoryBitMask = categoryHero;
        nodeBody.contactTestBitMask = categoryScreen | categoryEnemy;
        nodeHero.physicsBody = nodeBody;
        
    }
    
    //Create Jelly fish
    func startJellyfish() {

        let sizeX = UInt32(40)
        var randomX = CGFloat(arc4random_uniform(sizeX))
        
        nodeJellyfish.position = CGPointMake(-self.size.width/2,-self.size.height/2);
        self.addChild(nodeJellyfish)
        
        let jellyfish = SKSpriteNode(imageNamed: "jellyfish")
        jellyfish.size = CGSize(width:jellyfish.size.width/2, height:jellyfish.size.height/2)
        jellyfish.position = CGPoint(x:randomX, y: jellyfish.size.height/2)
        let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, jellyfish.size.width, jellyfish.size.height))
        borderBody.dynamic = false
        borderBody.categoryBitMask = categoryEnemy
        borderBody.affectedByGravity = false
        jellyfish.anchorPoint = CGPointMake(0, 0)
        jellyfish.physicsBody = borderBody
        nodeJellyfish.addChild(jellyfish)
        jellyfish.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-jellyfish.size.height, duration: 8 )))
        
        let jellyfish2 = SKSpriteNode(imageNamed: "jellyfish")
        jellyfish2.size = CGSize(width:jellyfish2.size.width/2, height:jellyfish2.size.height/2)
        jellyfish2.position = CGPoint(x: self.frame.width-randomX*1.5, y: jellyfish2.size.height/2+160)
        let borderBody2:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, jellyfish2.size.width, jellyfish2.size.height))
        borderBody2.dynamic = false
        borderBody2.categoryBitMask = categoryEnemy
        borderBody2.affectedByGravity = false
        jellyfish.anchorPoint = CGPointMake(0, 0)
        jellyfish.physicsBody = borderBody
        nodeJellyfish.addChild(jellyfish2)
        jellyfish2.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-jellyfish2.size.height, duration: 8 )))
    }

    
    func startEnemies(){
        
        // Corals
        for index in 1...10 {
            let randomX:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160) //-320 to -160  ---  -160 to 0
            var nodeEnemy = SKNode()
            
            // left
            let spriteLeft = SKSpriteNode(imageNamed:"coralOrangeLeft")
            spriteLeft.size = CGSizeMake(spriteLeft.size.width/2, spriteLeft.size.height/2)
            spriteLeft.position = CGPointMake(randomX,0)
            spriteLeft.zPosition = 5
            let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteLeft.size.width, spriteLeft.size.height))
            borderBody.dynamic = false
            borderBody.categoryBitMask = categoryEnemy
            borderBody.affectedByGravity = false
            spriteLeft.name = "coralOrangeLeft"
            spriteLeft.anchorPoint = CGPointMake(0, 0)
            spriteLeft.physicsBody = borderBody
            nodeEnemy.addChild(spriteLeft)
            
            // right
            let spriteRight = SKSpriteNode(imageNamed:"coralOrangeRight")
            spriteRight.size = CGSizeMake(spriteRight.size.width/2, spriteRight.size.height/2)
            spriteRight.position = CGPointMake(spriteLeft.position.x + spriteLeft.size.width + ditanceBetweenBars,0)
            spriteRight.zPosition = 5
            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteRight.size.width, spriteRight.size.height))
            borderBodyRight.dynamic = false
            borderBodyRight.categoryBitMask = categoryEnemy
            borderBodyRight.affectedByGravity = false
            spriteRight.name = "coralOrangeLeft"
            spriteRight.anchorPoint = CGPointMake(0, 0)
            spriteRight.physicsBody = borderBodyRight

            nodeEnemy.position = CGPointMake(0, lastYposition)
            nodeEnemy.addChild(spriteRight)
            
            nodeEnemies.addChild(nodeEnemy)
            lastYposition += ditanceFromBarToBar
        }
    }

    // MARK: - Game Loop
    
    //game loop
    override func didSimulatePhysics() {
        self.shouldRepositeNodes()
        self.centerOnNode(nodeHero)
        self.updatePoints()
    }
    
    //Here we reposition out of the screen jellyfish/enemies to the top of the screen again
    func shouldRepositeNodes() {
        let arrayJellyfish:Array<SKSpriteNode> = nodeJellyfish.children as Array<SKSpriteNode>
        for spriteJellyfish:SKSpriteNode in arrayJellyfish {
            if spriteJellyfish.position.y < -spriteJellyfish.size.height/2 {
                spriteJellyfish.position.y = -spriteJellyfish.size.height/2 + 160*4
            }
        }
        
        let arrayEnemies:Array<SKNode> = nodeEnemies.children as Array<SKNode>
        for nodeEnemy:SKNode in arrayEnemies {
            if nodeEnemy.position.y - nodeHero.position.y < -300.0 {
                nodeEnemy.position.y = lastYposition + ditanceFromBarToBar;
                lastYposition += ditanceFromBarToBar;
            }
        }
    }
    
    //To mantain the copter in the centered at the bottom of the screen
    func centerOnNode(node:SKNode) {
        let cameraPositionInScene = node.scene?.convertPoint(node.position, fromNode: node.parent!)
        
        node.parent?.position = CGPointMake(node.parent!.position.x, node.parent!.position.y - cameraPositionInScene!.y-self.frame.size.height/3);
    }
    
    
    func updatePoints() {
        nodePoints.text = "\(Int(nodeHero.position.y/300))"
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if !start {
            nodeHero.physicsBody?.affectedByGravity = true
//            spriteCopter.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([SKTexture(imageNamed:"booCopter1"),SKTexture(imageNamed:"booCopter2"),SKTexture(imageNamed:"booCopter3"),SKTexture(imageNamed:"booCopter4")], timePerFrame: 0.075)))
            nodeHero.physicsBody?.dynamic = true
        }
        start = true;
        
        for touch: AnyObject in touches {
            if gravityX > 0 {
                gravityX = -4
                self.physicsWorld.gravity = CGVectorMake(gravityX, 0.0) //0.0
                self.nodeHero.physicsBody?.applyImpulse(CGVectorMake(impulseX, impulseY))
                nodeHero.runAction(SKAction.rotateToAngle(+3.14/10, duration: 0.3))//rigth
            }
            else {
                gravityX = 4
                self.physicsWorld.gravity = CGVectorMake(gravityX, 0.0)
                self.nodeHero.physicsBody?.applyImpulse(CGVectorMake(-impulseX, impulseY))
                nodeHero.runAction(SKAction.rotateToAngle(-3.14/10, duration: 0.3))//left
            }
        }
        
        //We have to change the height of the physics bode to make it larger when the hero goes up
        let borderBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-self.frame.size.width/2, -self.frame.size.height/2, self.frame.size.width, self.frame.size.height+nodeHero.position.y+100))
        nodeWorld.physicsBody? = borderBody
        nodeWorld.physicsBody?.categoryBitMask = categoryScreen
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == categoryHero && (secondBody.categoryBitMask == categoryEnemy) {
            self.resetScene()
        }
//        if firstBody.categoryBitMask == categoryCopter && (secondBody.categoryBitMask == categoryEnemy || secondBody.categoryBitMask == categoryScreen) {
//            self.resetScene()
//        }
    }
    
    func resetScene() {
        viewController?.presentGameOverScene()
    }
}



