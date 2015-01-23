//
//  GameOverScene.swift
//  YellowSub
//
//  Created by Sam Wong on 19/01/2015.
//  Copyright (c) 2015 sam wong. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var viewController:GameViewController?
    var colorBackground:SKColor! = SKColor(red: 12/255, green: 77/255, blue: 105/255, alpha: 1.0)
    
    //Init
    override func didMoveToView(view: SKView) {
        
        let nodeLabel = SKLabelNode(fontNamed: "Lobster 1.4")
        nodeLabel.text = "game over"
        nodeLabel.fontSize = 50
        nodeLabel.fontColor = SKColor.whiteColor()
        nodeLabel.position = CGPointMake(self.frame.width/2, self.frame.height/3*2)
        nodeLabel.alpha = 0.0
        nodeLabel.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
        self.addChild(nodeLabel)
        
        let spriteFace = SKSpriteNode(imageNamed: "diver")
        spriteFace.size = CGSizeMake(spriteFace.size.width/2, spriteFace.size.height/2)
        spriteFace.position = CGPointMake(self.frame.width/2, -spriteFace.size.height/2)
        spriteFace.runAction(SKAction.moveToY(spriteFace.size.height/2, duration: 0.7))
        self.addChild(spriteFace)
        
        self.backgroundColor = self.colorBackground
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        viewController?.presentGameScene()
    }
}