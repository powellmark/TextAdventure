//
//  ViewController.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/21/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var inputBottomConstraint: NSLayoutConstraint!
    //console view is a custom class where all output goes (descriptions of rooms, descriptions of
    //actions, etc.)
    @IBOutlet var consoleView: TAConsoleView!
    @IBOutlet var inputField: UITextField!
    
    var roomManager: RoomManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //decorate the input field (add a colored border, color everything the same color as the text color).
        inputField.layer.borderWidth = 1
        inputField.layer.borderColor = inputField.textColor?.cgColor
        inputField.layer.cornerRadius = 5
        inputField.tintColor = inputField.textColor
        
        initializeWorld()
        
        displayCurrentRoom()
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @IBAction func submitCommand(_ sender: Any) {
        guard let input = inputField.text, input != "" else {
            return
        }
        
        consoleView.appendToConsole(">"+input)
        
        if let outputList = roomManager?.process(input) {
            for output in outputList {
                consoleView.appendToConsole(output)
            }
        }
        
        inputField.text = ""
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        inputField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        submitCommand(textField)
        
        return true
    }
}

//Handle keyboard showing/hiding
extension ViewController {
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        //modify the keyboard frame to account for the safe area (otherwise we'll offset the input field to be too high).
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let finalHeight = safeAreaFrame.intersection(keyboardFrameInView).height + 3 //add an offset of 3 pixels to give a little space
        
        //animate the text field with the keyboard
        if let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue, let animationCurveRaw = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
        
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
                self.additionalSafeAreaInsets.bottom = finalHeight
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.additionalSafeAreaInsets.bottom = finalHeight
            self.view.layoutIfNeeded()
        }
        
        consoleView.scrollToLastRow(false)
    }
}

extension ViewController {
    func initializeWorld() {
        roomManager = RoomManager()
        roomManager?.load()
    }
    
    func displayCurrentRoom() {
        guard let room = roomManager?.currentRoom else {
            return
        }
        
        consoleView.appendToConsole(room.description)
        for exit in room.exits {
            consoleView.appendToConsole(exit.exitDescription)
        }
    }
}
