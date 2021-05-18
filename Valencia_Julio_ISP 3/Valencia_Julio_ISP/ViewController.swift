//
//  ViewController.swift
//  Valencia_Julio_ISP
//
//  Created by Period Two on 1/8/19.
//  Copyright © 2019 Period Two. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    //OUtlets for my labels, buttons, etc
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var doubleScorePopOut: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var multiplier: UILabel!
    @IBOutlet weak var giveUp: UIButton!
    @IBOutlet weak var livesOne: UIImageView!
    @IBOutlet weak var livesTwo: UIImageView!
    @IBOutlet weak var livesThree: UIImageView!
    @IBOutlet weak var additionalLivesOutlet: UILabel!
    //variables that I use later to play my audio, using AVFoundation
    var coin : AVAudioPlayer = AVAudioPlayer()
    var death : AVAudioPlayer = AVAudioPlayer()
    var life : AVAudioPlayer = AVAudioPlayer()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainMenu = segue.destination as! MenuViewController
        mainMenu.scoreMenu = score
    }
    
    override func viewDidLoad() {
        //What I want to happen when the play screen first loads in, My additional lives set to zero
        additionalLivesOutlet.text = ""
        doubleScorePopOut.isHidden=true
        //Calling up my audio file from my sounds folder
        let sound = Bundle.main.path(forResource: "mario sound", ofType: "mp3")
        let deathSound = Bundle.main.path(forResource: "Mario Death Sound Effect", ofType: "mp3")
        let lifeSound = Bundle.main.path(forResource: "mario live up sound", ofType: "mp3")
        //Running my random number function, essentialy just picking two random number from 0 to 100, and appending it to an array
        for _ in 0...1 {
            randomNumbGen()
        }
        //sorting, and reversing the array so that the larger number is first in the array
        array.sort()
        array.reverse()
        //
        do {
            try coin = AVAudioPlayer(contentsOf: URL (fileURLWithPath:sound!))
        } catch {
            print(error)
        }
        do {
            try death = AVAudioPlayer(contentsOf: URL (fileURLWithPath:deathSound!))
        } catch {
            print(error)
        }
        do {
            try life = AVAudioPlayer(contentsOf: URL (fileURLWithPath:lifeSound!))
        } catch {
            print(error)
        }
        
        super.viewDidLoad()
        //for my leaderbaord
        if let setOfScores = UserDefaults.standard.value(forKey: "scores") as? [Int]{
            arrayOfScores = setOfScores
            if arrayOfScores.count >= 10 {
                arrayOfScores.remove(at: 0)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    //variables that I use later on in my code.
    var lives = 3
    var additiontalLives = 0
    var score = 0
    var myTimer = Timer()
    var myTime: Int = 100
    var array: [Int] = []
    var powerUp = 0
    var timesInARow = 0
    var arrayOfScores: [Int] = []
    var saveData = UserDefaults.standard
    
    //My random Number Generator, what it does is pick a number between one and 50, two times, and appends it to and arrau.
    func randomNumbGen() {
        let shrodem = Int.random(in: 0...50)
        if array.contains(shrodem){
            return
        } else {
           array.append(shrodem)
    }
    }
    //Function that saves the data once the game is over.
    func whenGameEnds() {
        arrayOfScores.append(score)
        UserDefaults.standard.set(arrayOfScores, forKey: "scores")
        
    }
    //function that start my timer.
    func timerBegins () {
        myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:{_ in self.codeTwoBeRun()})
    }
    //random variable.
    var index = 100
    //function that checks the current lives and according to the lives it does something.
    func liveChecker() {
        if lives <= 3{
            additionalLivesOutlet.text = ""
        }
        if lives == 4{
            additionalLivesOutlet.text = "+1"
        }
        if lives == 5 {
            additionalLivesOutlet.text = "+2"
        }
        if lives == 6 {
            additionalLivesOutlet.text = "+3"
        }
        if lives == 7 {
            additionalLivesOutlet.text = "+4"
        }
    }
    //code that is run every single second, or as long as my timer is running.
    func codeTwoBeRun () {
        myTime -= 1
        index -= 1
        print(array)
        if lives == 3{
            additionalLivesOutlet.text = ""
            livesThree.isHidden = false
            livesTwo.isHidden = false
            livesOne.isHidden = false
            giveUp.isEnabled = true
        }
        else if lives == 2 {
            additionalLivesOutlet.text = ""
            livesThree.isHidden = true
            livesTwo.isHidden = false
            livesOne.isHidden = false
            giveUp.isEnabled = true
        }
        else if lives == 1 {
            additionalLivesOutlet.text = ""
            livesThree.isHidden = true
            livesTwo.isHidden = true
            livesOne.isHidden = false
            giveUp.isEnabled = true
        }
        else if lives <= 0{
            whenGameEnds()
            livesThree.isHidden = true
            livesTwo.isHidden = true
            livesOne.isHidden = true
            let alert = UIAlertController(title: "Game Over", message: "You finished with a score of \(score). Press New Game to play again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated:true)
            death.play()
            myTime = 100
            index = 100
            powerUp = 0
            score = 0
            scoreOutlet.text = "0"
            for index in 0...15 {
                buttons[index].isEnabled = false
            }
            playButton.isEnabled = true
            giveUp.isEnabled = false
            myTimer.invalidate()
        }
       
        if myTime == index {
            marioSelector()
        }
        if myTime == 0 {
            myTimer.invalidate()
        }
                }
    //Picks which mario will appear every second, according to PowerUp, this code is being run as long is the timer is active.
    func marioSelector() {
        if array.isEmpty == false && myTime == array[0]  {
            powerUp = 2
            doubleScorePopOut.isHidden=false
            array.remove(at: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.doubleScorePopOut.isHidden=true
                if self.powerUp == 2 && self.timesInARow<=5 {
                    self.powerUp = 1
                }
                if self.powerUp == 2 && self.timesInARow >= 4 {
                    self.powerUp = 0
                }
                
            }
        }
        print("power is \(powerUp)")
        let flag = Int.random(in: 0...15)
        if powerUp == 0 {
            self.multiplier.text = "x1"
            UIView.transition(with: buttons[flag], duration: 0.25, options: .transitionFlipFromBottom , animations: nil, completion: nil)
            buttons[flag].setImage(#imageLiteral(resourceName: "220px-MarioNSMBUDeluxe"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttons[flag].setImage(#imageLiteral(resourceName: "download copy"), for: .normal)
            }
        }
        if powerUp == 1 {
            self.multiplier.text = "x2"
             UIView.transition(with: buttons[flag], duration: 0.25, options: .transitionFlipFromBottom , animations: nil, completion: nil)
            buttons[flag].setImage(#imageLiteral(resourceName: "c8955d574072ff60d4a919eb0e138de3"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.buttons[flag].setImage(#imageLiteral(resourceName: "download copy"), for: .normal)
            }
        }
        if powerUp == 2 {
             UIView.transition(with: buttons[flag], duration: 0.25, options: .transitionFlipFromBottom , animations: nil, completion: nil)
            buttons[flag].setImage(#imageLiteral(resourceName: "Golden_mario"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttons[flag].setImage(#imageLiteral(resourceName: "download copy"), for: .normal)
            }
        } else if powerUp == 3 {
             UIView.transition(with: buttons[flag], duration: 0.25, options: .transitionFlipFromBottom , animations: nil, completion: nil)
            buttons[flag].setImage(#imageLiteral(resourceName: "Dr_Mario_Miracle_Cure"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.timesInARow += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttons[flag].setImage(#imageLiteral(resourceName: "download copy"), for: .normal)
                
            }
            
        }
        if timesInARow >= 5 && timesInARow <= 8 {
            powerUp = 1
            
        } else if timesInARow == 9 {
            powerUp = 3
        }
        else if timesInARow >= 10 {
            powerUp = 1
        }
    }
    //When a button is pressed acording to its current image, different things will happen, such as score changing, and other variables increasing or decreasing
    @IBAction func allButtonsPressed(_ sender: UIButton) {
    
       let button = sender.tag
        if buttons[button].imageView?.image == #imageLiteral(resourceName: "220px-MarioNSMBUDeluxe") {
            coin.play()
            timesInARow += 1
            score += 1
            scoreOutlet.text = String(score)
            liveChecker()
        }
        if buttons[button].imageView?.image == #imageLiteral(resourceName: "Golden_mario") {
            coin.play()
            timesInARow += 1
            score += 10
            scoreOutlet.text = String(score)
            if powerUp == 2 && timesInARow>=5 {
                powerUp = 1
            }
            if powerUp == 2 && timesInARow <= 4 {
                powerUp = 0
            }
            liveChecker()
        }
        if buttons[button].imageView?.image == #imageLiteral(resourceName: "c8955d574072ff60d4a919eb0e138de3"){
            coin.play()
            timesInARow += 1
            score += 2
            scoreOutlet.text = String(score)
        }
        if buttons[button].imageView?.image == #imageLiteral(resourceName: "download copy") {
            lives -= 1
            if timesInARow == timesInARow && timesInARow != 0{
                timesInARow -= timesInARow
                powerUp = 0
            }
            liveChecker()
        }
        if buttons[button].imageView?.image == #imageLiteral(resourceName: "Dr_Mario_Miracle_Cure") {
            if timesInARow == timesInARow {
                timesInARow -= timesInARow
                powerUp = 0
            }
            lives += 1
            liveChecker()
            life.play()
            
        }
        print(lives)
    }
    // when my play button is clicked, it starts timer.
    @IBAction func play(_ sender: UIButton) {
        timerBegins()
        playButton.isEnabled = false
        lives = 3
        for index in 0...15 {
            buttons[index].isEnabled = true
        }
}
    //When you are playing the game this Give Up button is enabled, it will set time to zero essentially ending the game.
    @IBAction func giveUp(_ sender: Any) {
        whenGameEnds()
        let alert = UIAlertController(title: "Game Over", message: "You finished with a score of \(score). Press New Game to play again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated:true)
        lives = 3
        timesInARow = 0
        powerUp = 0
        index = 100
        if myTime >= 1 {
            myTimer.invalidate()            
        }
        myTime = 100
        score = 0
        scoreOutlet.text = "0"
        livesThree.isHidden = false
        livesTwo.isHidden = false
        livesOne.isHidden = false
        giveUp.isEnabled = false
        playButton.isEnabled = true
    }
}
