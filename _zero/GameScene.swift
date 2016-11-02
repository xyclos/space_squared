//
//  GameScene.swift
//  _zero
//
//  Created by Jake Johnson on 4/18/16.
//  Copyright (c) 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum Mode {
        case menu, play, action, `default`
    }
    
    var currentMode = Mode.default
    var actionHasStarted = false
    
    var score: Int = 0 {
        didSet {
            updateScore(score)
        }
    }
    
    var _hero = SKSpriteNode() as? Hero
    var _coin = SKSpriteNode() as? Coin
    let playField = SKShapeNode(rectOf: CGSize(width: 320, height: 320))
    
    let titleLabel = SKLabelNode(fontNamed:"Fipps-Regular")
    let playLabel = SKLabelNode(fontNamed: "Fipps-Regular")
    var scoreLabel = SKLabelNode(fontNamed: "Fipps-Regular")
    let hintLabel1 = SKLabelNode(fontNamed: "Fipps-Regular")
    let hintLabel2 = SKLabelNode(fontNamed: "Fipps-Regular")
    let hintLabel3 = SKLabelNode(fontNamed: "Fipps-Regular")
    
    let settingsNode = SKSpriteNode(imageNamed: "Menu")
    
    let damage = SKAction.playSoundFileNamed("damage.wav", waitForCompletion: false)
    let coin = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    let backgroundMusic = SKAction.repeatForever(SKAction.playSoundFileNamed("background.wav", waitForCompletion: true))
    
    var menuGroup = SKNode()
    
    //mark: actions
    let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 1)
    let fadeInAction2 = SKAction.fadeAlpha(to: 1, duration: 1)
    let moveUpAction = SKAction.moveBy(x: 0, y: 200, duration: 1)
    let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
    let moveDownAction = SKAction.moveBy(x: 0, y: -150, duration: 1)
    let killAction = SKAction.removeFromParent()
    
    var lastUpdateTimeInterval: CFTimeInterval? = 0
    
    override func didMove(to view: SKView) {
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        self.physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.black
        
        if let starField = SKEmitterNode(fileNamed: "StarField") {
            starField.position = CGPoint(x: size.width/2, y: size.height)
            starField.zPosition = -1000
            addChild(starField)
        }
        
        playSound(backgroundMusic)
        
        buildMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if let name = node.name {
                switch name {
                case "play":
                    currentMode = Mode.menu
                default:
                    currentMode = Mode.default
                }
            }
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        if currentMode == Mode.menu {
            hideMenu()
        } else if currentMode == Mode.play {
            showPlayField()
        } else if currentMode == Mode.action {
            spawnEnemies()
            actionHasStarted = true
        }
    }
    
    func shake() {
        let moveX1 = SKAction.move(by: CGVector(dx: -7 ,dy: 0), duration: 0.05)
        let moveX2 = SKAction.move(by: CGVector(dx: -10 ,dy: 0), duration: 0.05)
        let moveX3 = SKAction.move(by: CGVector(dx: 7 ,dy: 0), duration: 0.05)
        let moveX4 = SKAction.move(by: CGVector(dx: 10 ,dy: 0), duration: 0.05)
        
        let moveY1 = SKAction.move(by: CGVector(dx: 0, dy: -7), duration: 0.05)
        let moveY2 = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: 0.05)
        let moveY3 = SKAction.move(by: CGVector(dx: 0, dy: 7), duration: 0.05)
        let moveY4 = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 0.05)
        
        let trembleX = SKAction.sequence([moveX1, moveX4, moveX2, moveX3])
        let trembleY = SKAction.sequence([moveY1, moveY4, moveY2, moveY3])
        
        let nonHeroChildren = self.children.filter({ $0.name != "hero" })
        
        for child in nonHeroChildren {
            child.run(trembleX)
            child.run(trembleY)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask != contact.bodyB.categoryBitMask {
            let contactMask = contact.bodyA.categoryBitMask & contact.bodyB.categoryBitMask
            switch contactMask {
            case CategoryBitMasks.Projectile:
                score = 0
                playSound(damage)
                shake()
                break
            case CategoryBitMasks.Coin:
                _coin!.explode()
                playSound(coin)
                _coin!.respawn()
                score += 1
                break
            default: break
            }
        }
    }
    
    func playSound(_ sound : SKAction) {
        run(sound)
    }
    
    func buildMenu() {
        titleLabel.text = "_zero"
        titleLabel.fontSize = 30
        titleLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        addChild(titleLabel)
        
        playLabel.text = "play"
        playLabel.fontSize = 15
        playLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        playLabel.name = "play"
        
        menuGroup.addChild(playLabel)
        
        addChild(menuGroup)
        
        hintLabel1.text = "Swipe to move"
        hintLabel1.fontSize = 10
        hintLabel1.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 170)
        hintLabel1.alpha = 0.0
        
        hintLabel2.text = "Collect the yellow coins"
        hintLabel2.fontSize = 10
        hintLabel2.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 190)
        hintLabel2.alpha = 0.0
        
        hintLabel3.text = "Avoid the red enemies"
        hintLabel3.fontSize = 10
        hintLabel3.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 210)
        hintLabel3.alpha = 0.0
        
        addChild(hintLabel1)
        addChild(hintLabel2)
        addChild(hintLabel3)
        
        settingsNode.position = CGPoint(x: 100, y: 100)
        addChild(settingsNode);
    }
    
    func hideMenu() {
        let titleSequence = SKAction.sequence([moveDownAction])
        
        titleLabel.run(titleSequence)
        
        let menuSequence = SKAction.group([fadeOutAction, moveDownAction])
        
        menuGroup.run(menuSequence)
        
        let hintsSequence = SKAction.group([fadeInAction2])
        
        hintLabel1.run(hintsSequence)
        hintLabel2.run(hintsSequence)
        hintLabel3.run(hintsSequence)
        
        currentMode = Mode.play
    }
    
    func showPlayField() {
        
        playField.fillColor = SKColor.black
        playField.alpha = 0
        playField.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        playField.zPosition = -900
        
        addChild(playField)
        
        let playFieldSequence = SKAction.group([moveUpAction, fadeInAction])
        
        playField.run(playFieldSequence)
        
        currentMode = Mode.default
        
        scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.height*0.90)
        scoreLabel.fontSize = 20
        scoreLabel.color = SKColor.white
        scoreLabel.alpha = 0
        scoreLabel.text = "\(score)"
        
        addChild(scoreLabel)
        
        scoreLabel.run(fadeInAction2)
        
        _hero = Hero(color: SKColor.white, size: CGSize(width: 80, height: 80), scene: self)
        _hero!.alpha = 0
        addChild(_hero!)
        _hero!.run(fadeInAction2)
    
        
        _coin = Coin(color: SKColor.yellow, size: CGSize(width: 40, height: 40), scene: self)
        _coin!.alpha = 0
        addChild(_coin!)
        _coin!.run(fadeInAction2)
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "\(score)"
        
        if score == 1 && !actionHasStarted {
            currentMode = Mode.action
        }
    }
    
    func spawnEnemies() {
        let baseDelay = 5
        let delay = Double(max(baseDelay*self.score/score, baseDelay))
        let wait = SKAction.wait(forDuration: delay)
        let run = SKAction.run({
            let enemy = Projectile(color: SKColor.red, size: CGSize(width: 20, height: 20), scene: self)
            let opposingPositions = enemy.randomOpposingPositions()
            let randomTupleIndex = self.randomIndexFromTuple(opposingPositions)
            let firstPosition = randomTupleIndex == 0 ? opposingPositions.0 : opposingPositions.1
            let secondPosition = firstPosition == opposingPositions.0 ? opposingPositions.1 : opposingPositions.0
            enemy.position = firstPosition
            enemy.run(SKAction.sequence([SKAction.move(to: secondPosition, duration: 5), self.killAction]))
            self.addChild(enemy)
        })
        self.run(SKAction.repeatForever(SKAction.sequence([run, wait])))
        currentMode = Mode.default
    }
    
    func swipedRight(_ sender:UISwipeGestureRecognizer){
        guard let hero = _hero else {return}
        hero.move(.right)
    }
    
    func swipedLeft(_ sender:UISwipeGestureRecognizer){
        guard let hero = _hero else {return}
        hero.move(.left)
    }
    
    func swipedUp(_ sender:UISwipeGestureRecognizer){
        guard let hero = _hero else {return}
        hero.move(.up)
    }
    
    func swipedDown(_ sender:UISwipeGestureRecognizer){
        guard let hero = _hero else {return}
        hero.move(.down)
    }
    
    func randomIndexFromTuple<C>(_ tuple:C) -> Int {
        let mirror = Mirror(reflecting: tuple)
        let count = mirror.children.count
        return Int(arc4random_uniform(UInt32(count)))
    }

}
