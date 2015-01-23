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
    var colorBackground:SKColor! = SKColor(red: 14/255, green: 98/255, blue: 190/255, alpha: 1.0)
    var start:Bool = false
    
    let categoryCopter:UInt32   = 0x1 << 0
    let categoryEnemy:UInt32    = 0x1 << 1
    let categoryScreen:UInt32   = 0x1 << 2
    
    let linearDamping:CGFloat = 0.65
    let angularDamping:CGFloat = 1.0
    var gravityX:CGFloat = 6
    let impulseY:CGFloat = 4.0
    let impulseX:CGFloat = 10.0
    var lastYposition:CGFloat = 300.0
    let ditanceBetweenBars:CGFloat = 175.0
    let ditanceFromBarToBar:CGFloat = 300.0
    
    let horizontalGravity: CGFloat = 0.0
    let verticalGravity: CGFloat = 0.1
    
    //Nodes
    //SKSCENE
    let nodePoints = SKLabelNode()
    let nodeClouds = SKNode()
    let nodeWorld = SKNode()
    let nodeEnemies = SKNode()
    var nodeCopter = SKNode()
    var spriteCopter:SKSpriteNode!
    
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
        self.startDiver()
        //self.startJellyfish()
        self.startEnemies()
        nodeWorld.addChild(nodeEnemies)
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
        
        self.physicsWorld.gravity = CGVectorMake(self.horizontalGravity, self.verticalGravity)
        //self.physicsWorld.gravity = CGVectorMake(gravityX, 0.0)
        
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
        spriteGround.position = CGPointMake(0, -30)
        nodeWorld.addChild(spriteGround)
    }
    
    //Create Diver
    func startDiver() {
        nodeCopter.position = CGPointMake(0,0)
        nodeCopter.zPosition = 10
        
        spriteCopter = SKSpriteNode(imageNamed: "diver")
        spriteCopter.size = CGSizeMake(spriteCopter.size.width/3, spriteCopter.size.height/3)
        spriteCopter.position = CGPointMake(0,0)
        
        nodeCopter.addChild(spriteCopter)
        nodeWorld.addChild(nodeCopter)
        
        let nodeBody = SKPhysicsBody(circleOfRadius: 0.9*spriteCopter.frame.size.width/2)
        nodeBody.linearDamping = linearDamping
        nodeBody.angularDamping = angularDamping
        nodeBody.allowsRotation = true
        nodeBody.affectedByGravity = false
        nodeBody.categoryBitMask = categoryCopter;
        nodeBody.contactTestBitMask = categoryScreen | categoryEnemy;
        nodeCopter.physicsBody = nodeBody;
        
    }
    
    //Create clouds
    func startJellyfish() {
        nodeClouds.position = CGPointMake(-self.size.width/2,-self.size.height/2);
        self.addChild(nodeClouds)
        
        let cloud = SKSpriteNode(imageNamed: "jellyfish")
        cloud.size = CGSize(width:cloud.size.width/2, height:cloud.size.height/2)
        cloud.position = CGPoint(x: 220, y: cloud.size.height/2)
        nodeClouds.addChild(cloud)
        cloud.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud2 = SKSpriteNode(imageNamed: "jellyfish")
        cloud2.size = CGSize(width:cloud2.size.width/2, height:cloud2.size.height/2)
        cloud2.position = CGPoint(x: 95, y: cloud.size.height/2+160)
        nodeClouds.addChild(cloud2)
        cloud2.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud3 = SKSpriteNode(imageNamed: "jellyfish")
        cloud3.size = CGSize(width:cloud3.size.width/2, height:cloud3.size.height/2)
        cloud3.position = CGPoint(x: 220, y: cloud.size.height/2+160*2)
        nodeClouds.addChild(cloud3)
        cloud3.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud4 = SKSpriteNode(imageNamed: "jellyfish")
        cloud4.size = CGSize(width:cloud4.size.width/2, height:cloud4.size.height/2)
        cloud4.position = CGPoint(x: 95, y: cloud.size.height/2+160*3)
        nodeClouds.addChild(cloud4)
        cloud4.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
    }

    
    func startEnemies(){
        
        // Orange Corals
        var lastYpositionForOrangeCorals = lastYposition/2
        for index in 1...10 {
            let randomX:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160) //-320 to -160  ---  -160 to 0
            var nodeEnemy = SKNode()

            
            let spriteBarLeft = SKSpriteNode(imageNamed:"coralOrangeLeft")
            spriteBarLeft.size = CGSizeMake(spriteBarLeft.size.width/2, spriteBarLeft.size.height/2)
            spriteBarLeft.position = CGPointMake(randomX, 0)
            spriteBarLeft.zPosition = 5
//            let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteBarLeft.size.width, spriteBarLeft.size.height))
            let borderBody:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: spriteBarLeft.size)
//            let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, 250, 300))
            
            borderBody.dynamic = false
            borderBody.categoryBitMask = categoryEnemy
            borderBody.affectedByGravity = false
            spriteBarLeft.name = "coralRedLeft"
            spriteBarLeft.anchorPoint = CGPointMake(0, 0)
            spriteBarLeft.physicsBody = borderBody
            spriteBarLeft.color = UIColor.redColor()
            nodeEnemy.addChild(spriteBarLeft)
            
            let spriteBarRight = SKSpriteNode(imageNamed:"coralOrangeRight")
            spriteBarRight.size = CGSizeMake(spriteBarRight.size.width/2, spriteBarRight.size.height/2)
            spriteBarRight.position = CGPointMake(spriteBarLeft.position.x + spriteBarLeft.size.width + ditanceBetweenBars,0)
            spriteBarRight.zPosition = 5
//            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteBarRight.size.width, spriteBarRight.size.height))
            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: spriteBarRight.size)
//            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, 250, 300))
            borderBodyRight.dynamic = false
            borderBodyRight.categoryBitMask = categoryEnemy
            borderBodyRight.affectedByGravity = false
            spriteBarRight.name = "coralRedRight"
            spriteBarRight.anchorPoint = CGPointMake(0, 0)
            spriteBarRight.physicsBody = borderBodyRight
            nodeEnemy.position = CGPointMake(0, lastYpositionForOrangeCorals)
            nodeEnemy.addChild(spriteBarRight)
            
            nodeEnemies.addChild(nodeEnemy)
            
            let randomY:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160)
            lastYpositionForOrangeCorals += ditanceFromBarToBar
        }
        
//        // Red Corals
//        var lastYpositionForRedCorals = lastYposition
//        for index in 1...10 {
//            let randomX:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160) //-320 to -160  ---  -160 to 0
//            var nodeEnemy = SKNode()
//            
//            let spriteBarLeft = SKSpriteNode(imageNamed:"coralRedLeft")
//            spriteBarLeft.size = CGSizeMake(spriteBarLeft.size.width/2, spriteBarLeft.size.height/2)
//            spriteBarLeft.position = CGPointMake(randomX,0)
//            spriteBarLeft.zPosition = 5
//            let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteBarLeft.size.width, spriteBarLeft.size.height))
//            borderBody.dynamic = false
//            borderBody.categoryBitMask = categoryEnemy
//            borderBody.affectedByGravity = false
//            spriteBarLeft.name = "coralRedLeft"
//            spriteBarLeft.anchorPoint = CGPointMake(0, 0)
//            spriteBarLeft.physicsBody = borderBody
//            nodeEnemy.addChild(spriteBarLeft)
//            
//            let spriteBarRight = SKSpriteNode(imageNamed:"coralRedRight")
//            spriteBarRight.size = CGSizeMake(spriteBarRight.size.width/2, spriteBarRight.size.height/2)
//            spriteBarRight.position = CGPointMake(spriteBarLeft.position.x + spriteBarLeft.size.width + ditanceBetweenBars,0)
//            spriteBarRight.zPosition = 5
//            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteBarRight.size.width, spriteBarRight.size.height))
//            borderBodyRight.dynamic = false
//            borderBodyRight.categoryBitMask = categoryEnemy
//            borderBodyRight.affectedByGravity = false
//            spriteBarRight.name = "coralRedRight"
//            spriteBarRight.anchorPoint = CGPointMake(0, 0)
//            spriteBarRight.physicsBody = borderBodyRight
//            nodeEnemy.position = CGPointMake(0, lastYpositionForRedCorals)
//            nodeEnemy.addChild(spriteBarRight)
//            
//            nodeEnemies.addChild(nodeEnemy)
//            
//            let randomY:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160)
//            lastYpositionForRedCorals += ditanceFromBarToBar
//        }
    }

    // MARK: - Game Loop
    
    //game loop
    override func didSimulatePhysics() {
        self.shouldRepositeNodes()
        self.centerOnNode(nodeCopter)
        self.updatePoints()
    }
    
    //Here we reposition out of the screen clouds/enemies to the top of the sky again
    func shouldRepositeNodes() {
        let arrayClouds:Array<SKSpriteNode> = nodeClouds.children as Array<SKSpriteNode>
        for spriteCloud:SKSpriteNode in arrayClouds {
            if spriteCloud.position.y < -spriteCloud.size.height/2 {
                spriteCloud.position.y = -spriteCloud.size.height/2 + 160*4
            }
        }
        
        let arrayEnemies:Array<SKNode> = nodeEnemies.children as Array<SKNode>
        for nodeEnemy:SKNode in arrayEnemies {
            if nodeEnemy.position.y - nodeCopter.position.y < -300.0 {
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
        nodePoints.text = "\(Int(nodeCopter.position.y/300))"
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if !start {
            nodeCopter.physicsBody?.affectedByGravity = true
//            spriteCopter.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([SKTexture(imageNamed:"booCopter1"),SKTexture(imageNamed:"booCopter2"),SKTexture(imageNamed:"booCopter3"),SKTexture(imageNamed:"booCopter4")], timePerFrame: 0.075)))
            nodeCopter.physicsBody?.dynamic = true
        }
        start = true;
        
        for touch: AnyObject in touches {
            if gravityX > 0 {
                gravityX = -4
                self.physicsWorld.gravity = CGVectorMake(gravityX, 0.0)
                self.nodeCopter.physicsBody?.applyImpulse(CGVectorMake(impulseX, impulseY))
                nodeCopter.runAction(SKAction.rotateToAngle(+3.14/10, duration: 0.3))//rigth
            }
            else {
                gravityX = 4
                self.physicsWorld.gravity = CGVectorMake(gravityX, 0.0)
                self.nodeCopter.physicsBody?.applyImpulse(CGVectorMake(-impulseX, impulseY))
                nodeCopter.runAction(SKAction.rotateToAngle(-3.14/10, duration: 0.3))//left
            }
        }
        
        //We have to change the height of the physics bode to make it larger when the copter goes up
        let borderBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-self.frame.size.width/2, -self.frame.size.height/2, self.frame.size.width, self.frame.size.height+nodeCopter.position.y))
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
        if firstBody.categoryBitMask == categoryCopter && (secondBody.categoryBitMask == categoryEnemy) {
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



