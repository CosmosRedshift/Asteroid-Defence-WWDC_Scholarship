import Foundation
import UIKit
import PlaygroundSupport
import AVFoundation
import Darwin
import SpriteKit

public class AboutMe{
    
    
    //Set up view, elements and audioplayer
    var view = UIView()
    var smallLabel = UILabel()
    var bigLabel = UILabel()
    
    var audioPlayer = AVAudioPlayer()
    
    //Load loads up a scene about me and animates it
    public func load(){
        
        let backgroundColor1 = UIColor(red: 52.0/255.0, green: 129.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
        let textColor1 = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: 666, height: 500))
        view.backgroundColor = backgroundColor1
        
        PlaygroundPage.current.liveView = view
        
        
        let musicPath = URL(fileURLWithPath: Bundle.main.path(forResource: "happyMusic", ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: musicPath)
        } catch  {
            print("error")
        }
        
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        audioPlayer.numberOfLoops = -1
        
        
        let welcomeText = "Hello There!"
        let subText = "Before you play, here's something about me!"
        
        bigLabel = UILabel(frame: CGRect(x: view.frame.midX - view.frame.width/2.5, y: view.frame.midY - 120 + 5000, width: 700, height: 200))
        smallLabel = UILabel(frame: CGRect(x: view.frame.midX - view.frame.width/2.5 + 5000, y: view.frame.midY , width: 500, height: 44))
        
        bigLabel.text = welcomeText
        bigLabel.textColor = textColor1
        bigLabel.font = UIFont(name: "Copperplate", size: 75.0)
        smallLabel.textAlignment = .center
        view.addSubview(bigLabel)
        
        
        smallLabel.text = subText
        smallLabel.textColor = UIColor.white
        smallLabel.font = UIFont(name: "Helvetica", size: 20.0)
        smallLabel.textAlignment = .center
        view.addSubview(smallLabel)
        
        
        UIView.animate(withDuration: 2) {
            
            
            self.smallLabel.center.x -= 5000
            self.bigLabel.center.y -= 5000
            
        }
        
        delay(4) {
            UIView.animate(withDuration: 2, animations: {
                
                self.smallLabel.center.x += 9000
                self.bigLabel.center.y -= 9000
                
                self.delay(1, closure: {
                    self.infoView()
                    
                })
                
            })
            
        }
        
        
        
        
        
    }
    
    
    
    //infoView() loads a view with a summary and some details about me and my experience with coding
    func infoView(){
        
        let aboutMeBox = roundedView(frame: CGRect(x: view.frame.midX - view.frame.midX/2 - 40, y: view.frame.midY - view.frame.midY/2 - 100, width: 400, height: 450), cR: 40.0, cl: UIColor.white)
        
        aboutMeBox.backgroundColor = UIColor.white
        
        let nameLabel = UILabel(frame: CGRect(x: aboutMeBox.frame.midX - aboutMeBox.frame.midX/2 - 100, y: aboutMeBox.frame.midY - 120, width: 300, height: 44))
        let ageLabel = UILabel(frame: CGRect(x: aboutMeBox.frame.midX - aboutMeBox.frame.midX/2 - 100, y: aboutMeBox.frame.midY - 100, width: 300, height: 44))
        let descriptionLabel = UILabel(frame: CGRect(x: aboutMeBox.frame.midX - aboutMeBox.frame.midX/2 - 100, y: aboutMeBox.frame.midY - 140, width: 300, height: 350))
        let doneButton = UIButton(frame: CGRect(x: aboutMeBox.frame.midX - aboutMeBox.frame.midX/2 + 15  , y: aboutMeBox.frame.midY + 150, width: 50, height: 44))
        let pictureBox = UIImageView(frame: CGRect(x: 150, y: 15, width: 100, height: 100))
        pictureBox.image = UIImage(named: "MyPicture.png")
        pictureBox.layer.cornerRadius = 45
        pictureBox.layer.masksToBounds = true
        
        descriptionLabel.numberOfLines = 10
        descriptionLabel.contentMode = UIViewContentMode.top
        
        nameLabel.text = "Name: Yashvardhan Shailesh Mulki"
        nameLabel.textColor = UIColor.black
        
        ageLabel.text = "Age: 14"
        ageLabel.textColor = UIColor.black
        
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.text = "Hi! I'm Yash. I'm a 14 year old programmer who lives in the town of Oakville, Ontario in Canada. I started coding at the age of 12, when I began learning the newly released Swift programming language through online courses. Since then, I've published one app on the iTunes store and have started working on two more."
        
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        
        doneButton.addTarget(self, action: #selector(AboutMe.loadGame), for: .touchUpInside)
        
        aboutMeBox.addSubview(pictureBox)
        aboutMeBox.addSubview(nameLabel)
        aboutMeBox.addSubview(ageLabel)
        aboutMeBox.addSubview(descriptionLabel)
        aboutMeBox.addSubview(doneButton)
        view.addSubview(aboutMeBox)
        
    }
    
    
    //loadGame() calls a function that sets up the game's menu screen
    @objc func loadGame(){
        
        audioPlayer.stop()
        loadMainView()
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    public init() {
        
        
        
    }
    
    
    
    //Set up values and elements for use later on
    var time = 0
    
    var sceneView = SKView()
    var imageView = UIImageView()
    var button1 = UIButton()
    var nextButton = UIButton()
    var titleLabel = UILabel()
    var creditlabel = UILabel()
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 666, height: 500))
    var x = 0
    
    //Displays instructions view
    @objc func nextScene(){
        
        
        imageView.removeFromSuperview()
        button1.removeFromSuperview()
        titleLabel.removeFromSuperview()
        creditlabel.removeFromSuperview()
        
        let slide1Text = "Welcome! You are aboard starship K17. Unfortunately, we are passing through a junk field, and you must defend our ship from the incoming rocks."
        let slide2Text = "You will have one laser cannon. Simply tap somewhere to shoot a laser at it. Good luck!"
        
        
        let infoLabel = UILabel(frame: CGRect(x: mainView.frame.midX - mainView.bounds.width/3 - 20, y: mainView.frame.midY - 200 , width: 500, height: 200))
        infoLabel.numberOfLines = 5
        infoLabel.textColor = UIColor.white
        infoLabel.text = slide1Text
        infoLabel.font = UIFont(name: infoLabel.font.fontName, size: 25)
        infoLabel.textAlignment = .center
        infoLabel.alpha = 0
        
        mainView.addSubview(infoLabel)
        
        let infoLabel2 = UILabel(frame: CGRect(x: mainView.frame.midX - mainView.bounds.width/3 - 20, y: mainView.frame.midY - 50  , width: 500, height: 200))
        infoLabel2.numberOfLines = 5
        infoLabel2.textColor = UIColor.white
        infoLabel2.text = slide2Text
        infoLabel2.font = UIFont(name: infoLabel2.font.fontName, size: 25)
        infoLabel2.textAlignment = .center
        infoLabel2.alpha = 0
        
        mainView.addSubview(infoLabel2)
        
        
        
        
        //infoLabel.removeFromSuperview()
        
        nextButton = UIButton(frame: CGRect(x: mainView.frame.midX - 50, y: mainView.frame.midY + 150, width: 100, height: 44))
        
        nextButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        
        nextButton.setTitle("Start Game", for: .normal)
        nextButton.addTarget(self, action: #selector(AboutMe.goToGameScene), for: .touchDown)
        
        nextButton.alpha = 0
        
        mainView.addSubview(nextButton)
        
        UIView.animate(withDuration: 1) {
            
            self.nextButton.alpha = 1
            infoLabel.alpha = 1
            infoLabel2.alpha = 1
            
        }
        
    }
    
    
    //var timer = Timer()
    
    
    //Initialises an SKView and loads up the game
    @objc func goToGameScene(){
        
        
        
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 666, height: 500))
        
        
        sceneView.backgroundColor = UIColor.black
        
        PlaygroundPage.current.liveView = sceneView
        
        
        let scene = GameScene(size: sceneView.frame.size)
        
        scene.scaleMode = .aspectFit
        sceneView.presentScene(scene)
        
        
        sceneView.ignoresSiblingOrder = true
        sceneView.showsFPS = false
        
        //  timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameLoader.checkForCompletion), userInfo: nil, repeats: true)
        
    }
    
    //    @objc func checkForCompletion(){
    //
    //        time+=1
    //
    //        if time == 180{
    //
    //            timer.invalidate()
    //
    //            loadMainView()
    //        }
    //
    //    }
    
    @objc func update(){
        
        x += 1
        
    }
    
    
    //loads the game's menu screen, with a play button and title
    public func loadMainView(){
        
        
        
        let backgroundMusicPath = URL(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicPath)
        } catch  {
            print("error")
        }
        
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        mainView.backgroundColor = UIColor.black
        
        let buttonFrame = CGRect(x: mainView.frame.midX - 50, y: (mainView.frame.midY - 100) + 1000 , width: 100, height: 100)
        button1 = UIButton(frame: buttonFrame)
        
        let imageFrame = mainView.frame
        imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "MainScreenBackground.png")
        mainView.addSubview(imageView)
        
        
        
        button1.imageView?.contentMode = .scaleAspectFit
        button1.addTarget(self, action: #selector(AboutMe.nextScene), for: .touchDown)
        button1.setImage(UIImage(named: "StartButton.png"), for: .normal)
        
        
        mainView.addSubview(button1)
        
        titleLabel = UILabel(frame: CGRect(x: mainView.frame.midX - mainView.bounds.width/3, y: mainView.frame.midY - mainView.bounds.height/2 - 20, width: 500, height: 100))
        titleLabel.text = "Asteroid Defence"
        titleLabel.font = UIFont(name: "Copperplate", size: 50)
        titleLabel.textColor = UIColor.white
        mainView.addSubview(titleLabel)
        
        
        
        creditlabel = UILabel(frame: CGRect(x: 165, y: 400, width: 400, height: 44))
        creditlabel.text = "Sound Effects By : http://www.freesfx.co.uk"
        
        
        mainView.addSubview(creditlabel)
        
        presentView(v: mainView)
        
        UIView.animate(withDuration: 2) {
            
            
            self.button1.center.y = self.button1.center.y - 1000
            
        }
        
    }
    
    
    //Helper function to make it easier to present a view
    func presentView(v:UIView){
        
        PlaygroundPage.current.liveView = v
    }
    
    
    
}



  

    


