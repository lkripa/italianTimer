//
//  ViewController.swift
//  Timer()
//
//  Created by Lara Riparip on 10.07.19.
//  Copyright © 2019 Lara Riparip. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var timer = Timer()
    
    /// Default exercise number of seconds per round with setRestTime added later
    var counter = 31
    
    /// Number of rounds counter
    var counter_rounds = 0
    
    /// default exercise number of seconds per round
    var inputNumber = 31
    
    /// Total time counter
    var totalTime = 0
    
    /// Number of seconds to rest after exercise
    var setRestTime = 10
    
    /// Inital rest time
    var restTime = 11
    
    /// Check whether timer has been paused
    var isTimerRunning = false

    /// Check whether the user is exercising
    var isExerciseOn = true

    /// Check whether user selected secret booty exercise
    var isBootyOn = false
    
    /// Check whether this is the first exercise
    var firstExercise = true
    
    /// Default number of rounds for one cycle
    var rounds = 10
    
    /// Booty exercise names
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
    
    /// Determine which booty exercise is being shown
    var currentExercise = String()
    
    /// Bottom Label (states countdown or rest)
    @IBOutlet weak var label: UILabel!
    
    /// Label for counting the number of rounds
    @IBOutlet weak var label_rounds: UILabel!
    
    /// Label for counting the total time
    @IBOutlet weak var label_total: UILabel!
    
    /// Text Field for inputting the number of seconds per round
    @IBOutlet weak var textField: UITextField!
    
    /// Top Exercise Label
    @IBOutlet weak var exerciseLabel: UILabel!
    
    /// Only shown in the booty exercise for letting the user know of the next exercise
    @IBOutlet weak var upNext: UILabel!
    
     /// Total Timer Format
     func timeString(time:TimeInterval) -> String {
         let hours = Int(time) / 3600
         let minutes = Int(time) / 60 % 60
         let seconds = Int(time) % 60
         return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
     }
    
    /// Setup Attributes of Text Field View
    func setupTextField(){
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "seconds per round ",
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5), NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 41)!])

    }
    
    /// View for the Start of App
    func setupStartScreen(){
        label.text = "Ready?"
        label_rounds.text = "Round: \(counter_rounds)"
        label_total.text = timeString(time: TimeInterval(totalTime))
        
        upNext.isHidden = true
        exerciseLabel.isHidden = true
        exerciseLabel.textColor = UIColor.black
        label.textColor = UIColor.black
    }
    
     /// Verbal Countdown
     /// - Parameter number: number to be spoken outloud
     func verbalCountdown(_ number: Int){
        if 1 < number && number < 6 {
            speak("\(number)")
         }
     }
     
     /// View Rest Settings
     func rest(){
        isExerciseOn = false
        exerciseLabel.isHidden = false
        exerciseLabel.text = "Ready in"
    }

     /// View Exercise Settings
     func exercise(){
        isExerciseOn = true
        exerciseLabel.isHidden = false
        if isBootyOn {
            exerciseLabel.text = currentExercise
        } else {
            exerciseLabel.text = "Exercise"
        }
     }
    /// Check if mode on exercise or rest
    func exerciseOrRest(){
        if isExerciseOn && counter != 0 {
            if isBootyOn == false {
                exerciseLabel.text = "Exercise"
                speak("Esercizio")
            } else {
                exerciseLabel.text = currentExercise
                if firstExercise == false {
                    speak("Esercizio")
                }
            }
        } else {
            speak("Recupero")
            exerciseLabel.text = "Ready in"
        }
    }
    
    /// Start Time
     func start(){
         timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo:nil , repeats: true)
     }
     
     /// Set reset time to start round
     func reset(){
        timer.invalidate()
        restTime = setRestTime
        
        // no rest time for pulse
        if currentExercise == "Pulse"{
            restTime = 1
        }
         // for butterfly exercise, give time for the user to put on bands
        if currentExercise == "Up/Down Bridge & Butterfly" {
            restTime = 25
            // speak("Prendi miniband")
        }
        
         counter = inputNumber + restTime
         AudioServicesPlayAlertSound(SystemSoundID(1304)) // 1016 // 1322
     }
     
     /// Set up verbal commands while background app plays additional audio
     let audioSession = AVAudioSession.sharedInstance()
     let synth = AVSpeechSynthesizer()
     
    /// Speech Function
    /// - Parameter phrase: "String" to be spoken outloud
     func speak(_ phrase: String) {
                 let utterance = AVSpeechUtterance(string: phrase)
                 utterance.voice = AVSpeechSynthesisVoice(language:
                    "it-IT") // for Italian language
                    //"en-US") // for English language
                    // "de-DE") // for German language
                 
                 if self.synth.isSpeaking == false {
                     do {
                         try audioSession.setCategory(AVAudioSession.Category.ambient, mode: .default)
                     self.synth.speak(utterance)
                     } catch {
                         print("Speech Error")
                     }
                 }
     }
    
    // MARK:- Button
    
    /// Setup function after pressed
    /// - Parameter sender: "Boom Go" Button
    @IBAction func startTimer(sender: UIButton){
        // check if text field is not hidden and set number if empty (only for the initial start of app)
        if textField.isHidden == false {
            if textField.text!.isEmpty {
                inputNumber = 31
            } else {
                inputNumber =  (Int(self.textField.text!)! + 1)
            
                if inputNumber != 31 {
                counter = inputNumber
                }
            }
            // secret setting for activating booty workout
            if self.textField.text! == "0" {
                isBootyOn = true
                rounds = bootyExercise.count
                currentExercise = bootyExercise[counter_rounds]
                exerciseLabel.text = currentExercise
                speak("Preparatevi")
                restTime = 6
            }
        }

        // hide text field and stop editing
        textField.isHidden = true
        self.view.endEditing(true)
        
        // everytime the button is pressed, pause and play are activated
        isTimerRunning.toggle()
        exerciseLabel.isHidden = false
        
        // if button is pressed again, it pauses, else plays
        // also checking which phase of the exercise user is in after the button pressed
        if isTimerRunning {
            start()
            label.isHidden = false
            exerciseOrRest()
        } else {
            timer.invalidate()
            exerciseLabel.text = "Pause"
            label.isHidden = true
            speak("Timer in pausa")
        }
        
        // shows round timer after start
        if counter_rounds == 0 {
            counter_rounds = 1
            label_rounds.text = "Round: \(counter_rounds)"
        }
        
    }
    
    /// While timer is activated, for every second, counter and rest time will be subracted and total time added.
    @objc func timerAction(){
        counter -= 1
        label_total.text = timeString(time: TimeInterval(totalTime))
        totalTime += 1
        restTime -= 1
        firstExercise = false
        
        //When the counter gets to a certain time, case changes.
        switch counter {
        // if the case has a certain amount over the input number, then that is the rest time. Rest will be activated, else: the exercise time will be counting down.
        case inputNumber..<(inputNumber + 70) :
            // show rest time, else go to exercise countdown
            label.isHidden = false
            if restTime != 0 {
                rest()
                label.text = "\(restTime)"
            } else {
                label.text = "GO"
            }
        
            // prep for next exercise label
            if isBootyOn {
                upNext.isHidden = false
                upNext.text = "Up Next: \(currentExercise)"
            }
            
            // verbally countdown for restTime
            verbalCountdown(restTime)
            
        case 0:
            // only show timer when seconds is not 0
            label.isHidden = true
            upNext.isHidden = true
            
        default :
            label.isHidden = false
            upNext.isHidden = true
            label.text = "\(counter) seconds "
            exercise()

        }
        
        // at the start: counter is 31 and input number is (input)
        if counter == (inputNumber) && currentExercise != "Pulse" {
            upNext.isHidden = true
            exercise()
            speak("Esercizio")
            AudioServicesPlayAlertSound(SystemSoundID(1333))
        }
        
        
        // verbally countdown for exercise
        verbalCountdown(counter)
       
        // reset variables at the end of the round. Round starts with "Ready in" then exercise.
        // 10 rounds is one cycle for a minute break after
            if counter == 1 {
                if counter_rounds != rounds {
                    exerciseLabel.isHidden = true
                    if isBootyOn {
                        currentExercise = bootyExercise[counter_rounds]
                    }

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
                    // restart the round exercises for Booty
                    if isBootyOn {
                        currentExercise = bootyExercise[0]
                    }
                    label_rounds.text = "Round: \(counter_rounds)"
                    label.text = "Completo"
                    speak("Ciclo completo")
                    restTime = 60
                    counter = inputNumber + restTime
                }
            }
        
        // when isBootyOn activated, it will go through the workout and change times accordingly
        if isBootyOn {
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
        
        setupTextField()
        setupStartScreen()
    
        UIApplication.shared.isIdleTimerDisabled = true
        
        // start listening for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        // stop listening for keyboard events
        deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        // send a notification that a keyboard event is occuring
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
