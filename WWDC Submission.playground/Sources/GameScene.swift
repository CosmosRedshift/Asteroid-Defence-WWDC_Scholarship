import Foundation
import SpriteKit
import GameplayKit
import UIKit
import AVFoundation

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Set up AVAudioPlayers for in game sounds. Global sound is played by an AVAudioPlayer in AboutMe.swift
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayer3 = AVAudioPlayer()
    
    //Set up enum to manage colliders and contacts
    
    enum ColliderType: UInt32{
        
        case Asteroid = 1
        case Projectile = 2
        case Object = 4
        case AlternateObj = 8
        
    }
    
    //Set up necessary constants for use in the game
    
    var Pi = CGFloat()
    var DegreesToRadians = CGFloat()
    var RadiansToDegrees = CGFloat()
    
    //Track game values
    
    var health = 1.0
    var timeDigitOne = 2
    var timeDigitTwo = 0
    var timeDigitThree = 0
    var score = 0
    var lastContactPoint = CGPoint()
    var timeSinceLastContact = 0
    var fr = 0.0
    
    //Set up sprites
    
    var asteroid = SKSpriteNode()
    var bg = SKSpriteNode()
    var spaceShipBase = SKSpriteNode()
    var outlineBar = SKSpriteNode()
    var healthBar = SKSpriteNode()
    var healthLab = SKLabelNode()
    var timerLabel = SKLabelNode()
    var gun = SKSpriteNode()
    var laserProjectile = SKSpriteNode()
    var gameOverNode = SKLabelNode()
    
    //Set up values used to progressively increase difficulty over time
    
     let startingDuration: TimeInterval = 6.0
     let difficultyIncrease: TimeInterval = 0.05
     var asteroidCounter = 0
    
    
    var tp = Timer()
    
    //Minor helper function
    
    func incrementTimeContact(){
        
        timeSinceLastContact += 1
        
    }
    
    //Create asteroid and set it in motion
    
    func createAsteroidAtRandomPoint(){
        
        asteroid = SKSpriteNode(color: UIColor.white, size: CGSize(width: 60, height: 60))
        asteroid.position = CGPoint(x: RandomInt(min: 20, max: 600), y: 550)
        let asTexture = SKTexture(imageNamed: "asteroid.png")
        asteroid.texture = asTexture
        
        //Asteroid PhysicsBody Values
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: 22)
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        asteroid.physicsBody?.categoryBitMask = ColliderType.Asteroid.rawValue
        
        
        let collisionPosition = CGPoint(x: RandomInt(min: 20, max: 600), y: Int( spaceShipBase.position.y + spaceShipBase.size.height/2))
        
        let fallingDuration: TimeInterval = startingDuration - difficultyIncrease * TimeInterval(asteroidCounter)
        // let rotationAction = SKAction.rotate(byAngle: 360, duration: 10)
        let fallingAction = SKAction.move(to: collisionPosition, duration: fallingDuration)
        asteroid.run(fallingAction)
        self.addChild(asteroid)
        
        
        
        asteroidCounter+=1
        
    }
    
    
    //Physics Contact Management
    public func didBegin(_ contact: SKPhysicsContact) {
        
        //Asteroid is object 1, other item is object 2
        
        var object1 = SKSpriteNode()
        var object2 = SKSpriteNode()
        
     //Make sure that two contacts are nor registered
        
        let xThreshold:CGFloat = 40
        let yThreshold:CGFloat = 40
        
        
        let xDiff = abs(contact.contactPoint.x - lastContactPoint.x)
        let yDiff = abs(contact.contactPoint.y - lastContactPoint.y)
        
        if yDiff > yThreshold || xDiff > xThreshold || timeSinceLastContact > 1{
            
            print("lcp")
            lastContactPoint = contact.contactPoint
            timeSinceLastContact = 0
            
               //Test for asteroid/projectile contact, then remove appropriate sprites, change game values and play sounds
            
            if contact.bodyA.contactTestBitMask == ColliderType.Asteroid.rawValue && contact.bodyB.contactTestBitMask == ColliderType.Asteroid.rawValue{
                
                if contact.bodyA.categoryBitMask == ColliderType.Asteroid.rawValue{
                    
                    
                }else if contact.bodyB.categoryBitMask == ColliderType.Asteroid.rawValue{
                    
                    object2 = contact.bodyA.node as! SKSpriteNode
                    object1 = contact.bodyB.node as! SKSpriteNode
                    
                    let explosionPath = URL(fileURLWithPath: Bundle.main.path(forResource: "astd", ofType: "m4a")!)
                    
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: explosionPath)
                    } catch  {
                        print("error")
                    }
                    
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    
                }
                
                if object2.physicsBody?.categoryBitMask == ColliderType.Object.rawValue{
                    
                    
                    object1.removeAllActions()
                    object1.removeFromParent()
                    
                    let hitPath = URL(fileURLWithPath: Bundle.main.path(forResource: "craftHit", ofType: "mp3")!)
                    
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: hitPath)
                    } catch  {
                        print("error")
                    }
                    
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    
                    reduceHealthBy(num: 0.075)
                    
                    
                    
                }else if object2.physicsBody?.categoryBitMask == ColliderType.Projectile.rawValue{
                    
                    
                    
                    object1.removeAllActions()
                    object1.removeFromParent()
                    
                    object2.removeAllActions()
                    object2.removeFromParent()
                    
                    score += 1
                    
                }
            }
            
            
        }else{
            
            print("dbc")

        }
        
        
    }
    
    func incrementFR(){
        
        fr += 0.5
    }
    
    var trm = Timer()
    
    override public func didMove(to view: SKView) {
        
        
        //Initialise values for use later on
        Pi = CGFloat(Double.pi)
        DegreesToRadians = Pi/180
        RadiansToDegrees = 180 / Pi
        
        //Confirm loading
        print("GameView Loaded")
        
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.incrementTimeContact), userInfo: nil, repeats: true)
        
    
        //Set up timers to track time remaining and create asteroids at intervals
        trm = Timer.scheduledTimer(timeInterval: 2.5 , target: self, selector: #selector(GameScene.createAsteroidAtRandomPoint), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.changeTimeLab), userInfo: nil, repeats: true)
        
        //Timer to control fire rate
         tp = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.incrementFR), userInfo: nil, repeats: true)
        
        self.physicsWorld.contactDelegate = self
        
        //Set up moving background
        let bgTexture = SKTexture(image: UIImage(named: "InGameBackground.jpg")!)
        let moveBGAnimation = SKAction.move(by: CGVector(dx:-bgTexture.size().width, dy:0), duration: 25)
        let shiftBackground = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy:0), duration: 0)
        let repeatAnimationBg = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBackground]))
        var q = 0
        while(q < 3){
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x:  bgTexture.size().width * CGFloat(q), y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(repeatAnimationBg)
            self.addChild(bg)
            q+=1
            bg.zPosition = -1
        }
        
        //Initialise spaceship base, apply texture, create physicsBody and add into game scene
        let spaceshipTexture = SKTexture(imageNamed: "SpaceshipBase.png")
         spaceShipBase = SKSpriteNode(texture: spaceshipTexture, color: UIColor.black, size: CGSize(width: 666, height: 100))
        spaceShipBase.position = CGPoint(x: spaceShipBase.frame.width/2, y: spaceShipBase.frame.height - 50)
        
        spaceShipBase.physicsBody = SKPhysicsBody(rectangleOf: spaceShipBase.size)
        spaceShipBase.physicsBody?.isDynamic = false
        
        spaceShipBase.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        spaceShipBase.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        
        self.addChild(spaceShipBase)
        
        //Initialise gun mount base, apply texture, create physicsBody and add into game scene
        
        let gunMountTexture = SKTexture(imageNamed: "GunMount.png")
        let gunMount = SKSpriteNode(texture: gunMountTexture, color: UIColor.black, size: CGSize(width: 100, height: 50))
        gunMount.position = CGPoint(x: self.frame.width/2, y: spaceShipBase.frame.height + spaceShipBase.frame.height/4)
        gunMount.physicsBody = SKPhysicsBody(rectangleOf: gunMount.size)
        gunMount.physicsBody?.isDynamic = false
        gunMount.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        //gunMount.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        gunMount.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        
        //Initialise gun, apply texture, create physicsBody and add into game scene
        
        gun = SKSpriteNode(color: UIColor.black, size: CGSize(width: 25, height: 50))
        gun.texture = SKTexture(imageNamed: "Gun.png")
        gun.position = CGPoint(x: gunMount.frame.midX, y: gunMount.frame.midY + 15)
        gun.physicsBody = SKPhysicsBody(rectangleOf: gun.size)
        gun.physicsBody?.isDynamic = true
        gun.physicsBody?.affectedByGravity = false
        gun.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        gun.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        gun.physicsBody?.collisionBitMask = ColliderType.AlternateObj.rawValue
        
        
        gun.zPosition = 1
        gunMount.zPosition = 2
        
        self.addChild(gun)
        gun.anchorPoint = CGPoint(x: 0.5, y: 0.25)
        self.addChild(gunMount)
        
        
        
        //Set up health and time representations
        outlineBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 100, height: 15))
        outlineBar.position = CGPoint(x: self.frame.width - 100, y: self.frame.height - 20)
        self.addChild(outlineBar)
        
        healthBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 100, height: 15))
        healthBar.position = CGPoint(x: self.frame.width - 100, y: self.frame.height - 20)
        self.addChild(healthBar)
        
        healthLab = SKLabelNode(fontNamed: "Copperplate")
        healthLab.fontSize = 20
        healthLab.text = "Health:"
        healthLab.position = CGPoint(x: self.frame.width - 100 - healthBar.frame.width - 20, y: self.frame.height - 25)
        healthLab.fontColor = UIColor.white
        self.addChild(healthLab)
        
        timerLabel = SKLabelNode(fontNamed: "Copperplate")
        timerLabel.fontSize = 20
        timerLabel.text = "2:00"
        timerLabel.position = CGPoint(x: 50, y: self.frame.height - 25)
        timerLabel.fontColor = UIColor.white
        self.addChild(timerLabel)
        
    }
    
    
    //Update timer label
    func changeTimeLab(){
        
        if timeDigitThree != 0{
            
            timeDigitThree-=1
            
            
        }else{
            
            if timeDigitTwo != 0{
                
                timeDigitTwo-=1
                timeDigitThree = 9
                
            }else{
                
                if timeDigitOne != 0{
                    
                    timeDigitOne -= 1
                    timeDigitTwo = 5
                    timeDigitThree = 9
                    
                }else{
                    
                    endGame()
                    
                }
                
            }
            
        }
        
        timerLabel.text = "\(timeDigitOne):\(timeDigitTwo)\(timeDigitThree)"
    }
    
    
    
    //Reduce health of space ship (player)
    func reduceHealthBy(num:Double){
        
        health = health - num
        healthBar.size = CGSize(width: health * 100.0, height: 15)
        healthBar.position = CGPoint(x: self.frame.width - 100 - CGFloat(100 * (1.0 - health)/2), y: self.frame.height - 20)
        
        if health <= 0.0{
            
            endGame()
            
        }
        
    }
    
    
    //End the game, display score and ending scene
    func endGame(){
    
        trm.invalidate()
        tp.invalidate()
        
        self.removeAllChildren()
        self.removeAllActions()
        
        self.isUserInteractionEnabled = false
        
        gameOverNode = SKLabelNode(text: "Game Over. Score: \(score)")
        gameOverNode.fontSize = 40
        gameOverNode.fontName = "Copperplate"
        gameOverNode.fontColor = UIColor.white
        gameOverNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(gameOverNode)

        
    }
    
    
    
    //Function to turn gun and shoot projectiles
    func shootGun(touchPoint:CGPoint){
        
        //Calculate necessary constants
        
        let laserRadius: CGFloat = 90
        let deltaX = touchPoint.x - gun.position.x
        let deltaY = touchPoint.y - gun.position.y
        let angle = atan2(deltaY, deltaX)
        
        let p = angle - 90 * DegreesToRadians
        
        gun.zRotation = p
        
        if fr > 0.5{
            
            fr = 0
        
        //Set up laser projectile
        laserProjectile = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 10))
        laserProjectile.texture = SKTexture(imageNamed: "LaserProjectile.png")
        laserProjectile.position = gun.position
        laserProjectile.physicsBody = SKPhysicsBody(rectangleOf: laserProjectile.size)
        laserProjectile.physicsBody?.isDynamic = true
        laserProjectile.physicsBody?.affectedByGravity = false
        laserProjectile.zRotation = p
        laserProjectile.physicsBody?.categoryBitMask = ColliderType.Projectile.rawValue
        laserProjectile.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        

        //Project vector for endpoint outside screen
        
        var destination1 = CGPoint.zero
        if deltaY > 0 {
            destination1.y = size.height + laserRadius
        } else {
            destination1.y = -laserRadius         }
        destination1.x = gun.position.x +
            ((destination1.y - gun.position.y) / deltaY * deltaX)
        
        var destination2 = CGPoint.zero
        if deltaX > 0 {
            destination2.x = size.width + laserRadius
        } else {
            destination2.x = -laserRadius
        }
        destination2.y = gun.position.y +
            ((destination2.x - gun.position.x) / deltaX * deltaY)
        
        var destination = destination2
        if abs(destination1.x) < abs(destination2.x) || abs(destination1.y) < abs(destination2.y) {
            destination = destination1
        }
        
        
        //Fire the laser
        let speed:CGFloat = 200.0
        let distance = sqrt(pow(destination.x - gun.position.x, 2) +
            pow(destination.y - gun.position.y, 2))
        let duration = TimeInterval(distance / speed)
        let fireAction = SKAction.move(to: destination, duration: duration)
        laserProjectile.run(fireAction)
        
        laserProjectile.run(fireAction)
        self.addChild(laserProjectile)
        
        
        //Play shot audio
        let shotPath = URL(fileURLWithPath: Bundle.main.path(forResource: "laser", ofType: "mp3")!)
        
        do {
            audioPlayer3 = try AVAudioPlayer(contentsOf: shotPath)
        } catch  {
            print("error")
        }
        
        audioPlayer3.volume = 70
        
        audioPlayer3.prepareToPlay()
        audioPlayer3.play()
            
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Shoot Gun
        shootGun(touchPoint: touches.first!.location(in: self))
        
        
        
    }
    
    
    //Generate Random Integer
    func RandomInt(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max-(min-1)))) + min
    }
    
    
    
}

    
