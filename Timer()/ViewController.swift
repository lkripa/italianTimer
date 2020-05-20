//
//  ViewController.swift
//  Timer()
//
//  Created by Lara Riparip on 10.07.19.
//  Copyright © 2019 Lara Riparip. All rights reserved.
//


// THINGS TO DO:
// it is currently slow after I hid the labels.
// fix the 0 seconds in the start

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var timer = Timer()
    var counter = 31
    var counter_rounds = 0
    var inputNumber = 31
    var totalTime = 0
    var setRestTime = 10 //20
    var restTime = 11 //21
    var isTimerRunning = false
    var isExerciseOn = true
    let audioSession = AVAudioSession.sharedInstance()
    var isBootyOn = false
    var rounds = 10
    let bootyExercise = ["Jumping Squats",
                         "Reverse Lunge Kick (Right)",
                         "Reverse Lunge Kick (Left)",
                         "Donkey Kick (Right)", "Pulse",
                         "Donkey Kick (Left)", "Pulse",
                         "Fire Hydrant (Right)", "Pulse",
                         "Fire Hydrant (Left)", "Pulse",
                         "Corner Kick (Right)", "Pulse",
                         "Corner Kick (Left)", "Pulse",
                         "Corner Up & Down (Right)",
                         "Corner Up & Down (Left)",
                         "Spider Kick (Right)", "Pulse",
                         "Spider Kick (Left)", "Pulse",
                         "Up/Down Bridge & Butterfly", "Pulse",
                         "Clam (Right)", "Pulse",
                         "Clam (Left)", "Pulse",
                         "Forward & Backward Walk",
                         "Side to Side Walk",
                         "Tap Out (Right)", "Tap Out (Left)" ]
    
    var currentExercise = ""
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label_rounds: UILabel!
    @IBOutlet weak var label_total: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var exerciseLabel: UILabel!
    
     // Timer Format
     func timeString(time:TimeInterval) -> String {
         let hours = Int(time) / 3600
         let minutes = Int(time) / 60 % 60
         let seconds = Int(time) % 60
         return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
     }
     
     // Verbal Countdown
     func verbalCountdown(_ number: Int){
        for i in 2...5 {
             if number == i {
                        speak("\(number)")
             }
         }
     }
     
     // Rest Settings
     func rest(){
        isExerciseOn = false
        exerciseLabel.isHidden = false
        exerciseLabel.text = "Ready in"

    }
    
     // Exercise Settings
     func exercise(){
        isExerciseOn = true
        exerciseLabel.isHidden = false
        if isBootyOn == false {
            exerciseLabel.text = "Exercise"
        } else {
            exerciseLabel.text = currentExercise
        }
     }
     
     // MARK:- Reset Time
     func start(){
         timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo:nil , repeats: true)
     }
     
     // MARK:- Reset time to restart round
     func reset(){
         timer.invalidate()
         restTime = setRestTime
         if currentExercise == "Pulse"{
                    restTime = 1
                }
         counter = inputNumber + restTime
         AudioServicesPlayAlertSound(SystemSoundID(1304)) // 1016 // 1322
     }
     
     // MARK:- Speech Function
     let synth = AVSpeechSynthesizer()
     func speak(_ phrase: String) {
                 let utterance = AVSpeechUtterance(string: phrase)
                 utterance.voice = AVSpeechSynthesisVoice(language:
                     "it-IT")
                     //"en-US") // for English language
                 
                 if self.synth.isSpeaking == false {
                     do{
                         try audioSession.setCategory(AVAudioSession.Category.ambient, mode: .default)
                     self.synth.speak(utterance)
                     } catch {
                         print("Speech Error")
                     }
                 }
     }
    
    // MARK:- Button Activation
    @IBAction func startTimer(sender: UIButton){
        // check if text field is not hidden and set number if empty
        if textfield.isHidden == false {
            if textfield.text!.isEmpty {
                inputNumber = 31
            } else {
                inputNumber =  (Int(self.textfield.text!)! + 1)
            
                if inputNumber != 31 {
                counter = inputNumber
                }
            }
            if self.textfield.text! == "0" {
                isBootyOn = true
                rounds = bootyExercise.count
                currentExercise = bootyExercise[counter_rounds]
                exerciseLabel.text = currentExercise
                speak("Preparatevi")
            }
        }

        // hide text field and stop editing
        textfield.isHidden = true
        self.view.endEditing(true)
        
        // everytime the button is pressed, pause and play are activated
        isTimerRunning.toggle()
        
        // if button is pressed again, it pauses, else plays
        // also checking which phase of the exercise user is in
        if isTimerRunning == false {
            timer.invalidate()
            exerciseLabel.isHidden = false
            exerciseLabel.text = "Pause"
            label.isHidden = true
            speak("Timer in Pause")
        } else {
            start()
            label.isHidden = false
            if isExerciseOn == true {
                exerciseLabel.isHidden = false
                if isBootyOn == false {
                    exerciseLabel.text = "Exercise"
                    speak("Esercizio")
                } else {
                    exerciseLabel.text = currentExercise
                    speak("Esercizio")
                }
            } else {
                speak("Recupero")
                exerciseLabel.isHidden = false
                exerciseLabel.text = "Ready in"
            }
        }
        
        // shows round timer after start
        if counter_rounds == 0 {
            counter_rounds = 1
            label_rounds.text = "Round: \(counter_rounds)"
        }
        
    }
    
    // MARK:- Timer
    // As timer goes on, subtract counter, total time, and rest time
    @objc func timerAction(){
        counter -= 1
        label_total.text = timeString(time: TimeInterval(totalTime))
        totalTime += 1
        restTime -= 1
        
        // When the counter gets to a certain time, case changes.
        switch counter {
        // if the case has a certain amount over the input number, then that is the rest time. Rest will be activated, else: the exercise time will be counting down.
        
        case inputNumber..<(inputNumber + setRestTime) :
            // show rest time, else go to exercise countdown
            if restTime != 0 {
                rest()
                label.isHidden = false
                label.text = "\(restTime)"
            } else {
                label.isHidden = false
                label.text = "GO"
            }
            // verbally countdown for resttime
            verbalCountdown(restTime)
            
        case inputNumber..<(inputNumber + 60):
            // show after 10 rounds 1 minute rest time, else go to exercise countdown
            if restTime != 0 {
                    rest()
                    label.isHidden = false
                    label.text = "\(restTime)"
            } else {
                label.isHidden = false
                label.text = "GO"
            }
            verbalCountdown(restTime)
            
        default :
            label.isHidden = false
            label.text = "\(counter) seconds "
            exercise()

        }
        
        // At the start: counter is 31 and input number is (input)
        if counter == (inputNumber) && currentExercise != "Pulse" {
            exercise()
            speak("Esercizio")
            AudioServicesPlayAlertSound(SystemSoundID(1333))
        }
        
        
        // verbally countdown for exercise
        verbalCountdown(counter)
       
        // Reset variables at the end of the round. Round starts with "Ready in" then exercise
            if counter == 1 {
                if counter_rounds != rounds {
                    exerciseLabel.isHidden = true
                    currentExercise = bootyExercise[counter_rounds]
                    if currentExercise == "Pulse"{
                        speak("Impulso")
                    } else {
                        speak("Recupero")
                        label.isHidden = false
                        label.text = "Rest"
                    }
                    reset()
                    start()
                    counter_rounds += 1
                    label_rounds.text = "Round: \(counter_rounds)"
                } else {
                    counter_rounds = 1
                    label_rounds.text = "Round: \(counter_rounds)"
                    label.text = "Completo"
                    speak("Ciclo completo")
                    restTime = 60
                    counter = inputNumber + restTime
                }
            }
        
        
        if isBootyOn == true {
            exerciseLabel.isHidden = false
            switch currentExercise {
                
            case "Pulse" :
                inputNumber = 15 + 1
                counter = inputNumber + restTime
            case _ where ["Corner Up & Down (Right)", "Corner Up & Down (Left)"].contains(currentExercise) :
                inputNumber = 60 + 1
                counter = inputNumber + restTime
            case _ where ["Forward & Backward Walk", "Side to Side Walk", "Tap Out (Right)", "Tap Out (Left)"].contains(currentExercise):
                inputNumber = 30 + 1
                counter = inputNumber + restTime
            default :
                inputNumber = 45 + 1
                counter = inputNumber + restTime
            }
            
        }
    }
    

    // MARK:- Initial app setup
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.text = "Ready?"
        label_rounds.text = "Round: \(counter_rounds)"
        label_total.text = timeString(time: TimeInterval(totalTime))
        
        self.exerciseLabel.isHidden = true
        self.exerciseLabel.textColor = UIColor.black
        
        self.view.backgroundColor = UIColor.black
        self.label.textColor = UIColor.black
        // self.label_total.textColor = UIColor.darkGray
        // self.label_rounds.textColor = UIColor.darkGray
    
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        // Stop listening for keyboard events
        deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        // Send a notification that a keyboard event is occuring
        @objc func keyboardWillChange(notification: Notification) {
            print("Keyboard will show: \(notification.name.rawValue)")
            
            // The screen will only change if the screen is in Landscape mode
            if UIDevice.current.orientation.isPortrait{
                view.frame.origin.y = -100
            }
            // After the keyboard is hidden, the screen will be in the original position
            if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
            }
        }
}
