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
//    var colorBackground:SKColor! = SKColor(red: 20/255, green: 129/255, blue: 197/255, alpha: 1.0)
    var colorBackground:SKColor! = SKColor(red: 12/255, green: 77/255, blue: 105/255, alpha: 1.0)
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
        //self.initBackground()
        self.initBubbleEmitter()
        self.initPhysics()
        self.initFooter()
        self.startCopter()
        //self.startClouds()
        self.startEnemies()
        //self.startFish()
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
    
    
    func initBackground() {
        let spriteBackground = SKSpriteNode(imageNamed: "deepsea")
        //spriteBackground.zPosition = 100
        nodeWorld.addChild(spriteBackground)
    }
    
    func initFooter() {
//        self.nodeFooter = SKEmitterNode(fileNamed: "SmokeScene.sks")
//        self.nodeFooter.name = "nodeFooter"
////        self.nodeFooter.particlePositionRange = CGVectorMake(CGRectGetWidth(self.view!.frame), 0.0)
//        self.nodeFooter.position = CGPointMake(0, -350.0)
//        //self.insertChild(nodeFooter, atIndex: 0)
//        self.addChild(self.nodeFooter)
        
        
        let spriteGround = SKSpriteNode(imageNamed: "coralfooter")
        spriteGround.zPosition = 1
        spriteGround.size = CGSizeMake(spriteGround.size.width/2, spriteGround.size.height/4)
        spriteGround.position = CGPointMake(0, -30)
        nodeWorld.addChild(spriteGround)
    }
    
    //Create copter
    func startCopter() {
        nodeCopter.position = CGPointMake(0,0)
        nodeCopter.zPosition = 10
        
        spriteCopter = SKSpriteNode(imageNamed: "yellowSub")
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
    func startClouds() {
        nodeClouds.position = CGPointMake(-self.size.width/2,-self.size.height/2);
        self.addChild(nodeClouds)
        
        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.size = CGSize(width:cloud.size.width/2, height:cloud.size.height/2)
        cloud.position = CGPoint(x: 220, y: cloud.size.height/2)
        nodeClouds.addChild(cloud)
        cloud.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud2 = SKSpriteNode(imageNamed: "cloud")
        cloud2.size = CGSize(width:cloud2.size.width/2, height:cloud2.size.height/2)
        cloud2.position = CGPoint(x: 95, y: cloud.size.height/2+160)
        nodeClouds.addChild(cloud2)
        cloud2.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud3 = SKSpriteNode(imageNamed: "cloud")
        cloud3.size = CGSize(width:cloud3.size.width/2, height:cloud3.size.height/2)
        cloud3.position = CGPoint(x: 220, y: cloud.size.height/2+160*2)
        nodeClouds.addChild(cloud3)
        cloud3.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud4 = SKSpriteNode(imageNamed: "cloud")
        cloud4.size = CGSize(width:cloud4.size.width/2, height:cloud4.size.height/2)
        cloud4.position = CGPoint(x: 95, y: cloud.size.height/2+160*3)
        nodeClouds.addChild(cloud4)
        cloud4.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height-cloud.size.height, duration: 5 )))
    }

    
    func startEnemies(){
        
        // Orange Corals
        for index in 1...10 {
            
            var nodeEnemy = SKNode()
            
            
        }
        
        
        // Red Corals
        for index in 1...10 {

            let randomX:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160) //-320 to -160  ---  -160 to 0
            
            var nodeEnemy = SKNode()
            
            //BARS
            let spriteBarLeft = SKSpriteNode(imageNamed:"coralRedLeft")
            spriteBarLeft.size = CGSizeMake(spriteBarLeft.size.width/2, spriteBarLeft.size.height/2)
            spriteBarLeft.position = CGPointMake(randomX,0)
            spriteBarLeft.zPosition = 5;
            let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteBarLeft.size.width, spriteBarLeft.size.height))
            borderBody.dynamic = false;
            borderBody.categoryBitMask = categoryEnemy;
            borderBody.affectedByGravity = false;
            spriteBarLeft.name = "enemyBarLeft";
            spriteBarLeft.anchorPoint = CGPointMake(0, 0)
            spriteBarLeft.physicsBody = borderBody;
            nodeEnemy.addChild(spriteBarLeft)
            
            let spriteBarRight = SKSpriteNode(imageNamed:"coralRedRight")
            spriteBarRight.size = CGSizeMake(spriteBarRight.size.width/2, spriteBarRight.size.height/2)
            spriteBarRight.position = CGPointMake(spriteBarLeft.position.x + spriteBarLeft.size.width + ditanceBetweenBars,0)
            spriteBarRight.zPosition = 5;
            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, spriteBarRight.size.width, spriteBarRight.size.height))
            borderBodyRight.dynamic = false;
            borderBodyRight.categoryBitMask = categoryEnemy
            borderBodyRight.affectedByGravity = false;
            spriteBarRight.name = "enemyBarRight";
            spriteBarRight.anchorPoint = CGPointMake(0, 0)
            spriteBarRight.physicsBody = borderBodyRight
            
            //HAMMERS
            let spriteSwingLeft = SKSpriteNode(imageNamed: "jellyfish")
            spriteSwingLeft.size = CGSizeMake(spriteSwingLeft.size.width/2, spriteSwingLeft.size.height/2)
            spriteSwingLeft.zPosition = 4
            spriteSwingLeft.anchorPoint = CGPointMake(0.5, 1)
            spriteSwingLeft.position = CGPointMake(randomX+141,9)
            spriteSwingLeft.zRotation = -3.14/8
            
            let spriteSwingRight = SKSpriteNode(imageNamed: "jellyfish")
            spriteSwingRight.size = CGSizeMake(spriteSwingRight.size.width/2, spriteSwingRight.size.height/2)
            spriteSwingRight.zPosition = 4
            spriteSwingRight.anchorPoint = CGPointMake(0.5, 1)
            spriteSwingRight.position = CGPointMake(randomX+141+ditanceBetweenBars+37 ,9)
            spriteSwingRight.zRotation = -3.14/8
            
            let borderBodySwings = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-spriteSwingLeft.size.width/2, -spriteSwingLeft.size.height, spriteSwingLeft.size.width*0.9, 0.4*spriteSwingLeft.size.height))
            borderBodySwings.dynamic = false
            borderBodySwings.categoryBitMask = categoryEnemy
            borderBodySwings.affectedByGravity = true
            spriteSwingLeft.name = "enemySwing"
            spriteSwingLeft.physicsBody = borderBodySwings
            
            let borderBodySwingsRight = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-spriteSwingRight.size.width/2, -spriteSwingRight.size.height, spriteSwingRight.size.width*0.9, 0.4*spriteSwingRight.size.height))
            borderBodySwingsRight.dynamic = false
            borderBodySwingsRight.categoryBitMask = categoryEnemy
            borderBodySwingsRight.affectedByGravity = false
            spriteSwingRight.name = "enemySwing"
            spriteSwingRight.physicsBody = borderBodySwingsRight
            
//            let actionSwing:SKAction = SKAction.sequence([SKAction.rotateByAngle(3.14/4, duration: 1),SKAction.rotateByAngle(-3.14/4, duration: 1)])
//            spriteSwingLeft.runAction(SKAction.repeatActionForever(actionSwing))
//            spriteSwingRight.runAction(SKAction.repeatActionForever(actionSwing))
            
            //Final set up
            nodeEnemy.addChild(spriteSwingLeft)
            nodeEnemy.addChild(spriteSwingRight)
            
            nodeEnemy.position = CGPointMake(0, lastYposition)
            nodeEnemy.addChild(spriteBarRight)
            
            nodeEnemies.addChild(nodeEnemy)
            
            //7
            let randomY:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160)
            lastYposition += ditanceFromBarToBar
        }
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
        if firstBody.categoryBitMask == categoryCopter && (secondBody.categoryBitMask == categoryEnemy || secondBody.categoryBitMask == categoryScreen) {
            self.resetScene()
        }
    }
    
    func resetScene() {
        viewController?.presentGameOverScene()
    }
}
