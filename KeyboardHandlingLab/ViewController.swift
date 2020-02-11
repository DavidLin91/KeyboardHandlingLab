//
//  ViewController.swift
//  KeyboardHandlingLab
//
//  Created by David Lin on 2/10/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var backgroundGradient: UIView!
    @IBOutlet weak var superMarioHeight: NSLayoutConstraint!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var originalYConstraint: NSLayoutConstraint!
    
    private var keyboardIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        // creating color literals    #colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1)
        gradientLayer.colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor,#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor, #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradient.layer.addSublayer(gradientLayer)
        registerForKeyboardNotifs()
        passwordTextField.delegate = self
        userNameTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           unregisteredForKeyboardNotifs()
       }
    
    
    
    
    private func registerForKeyboardNotifs() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    private func unregisteredForKeyboardNotifs() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        //UIKeyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide(_  notification: NSNotification) {
        //TODO: complete
    }
    
    private func moveKeyboardUp(_ height: CGFloat) {
        
        if keyboardIsVisible { return }
        originalYConstraint = superMarioHeight // save original value
        superMarioHeight.constant -= height // (height * 0.80)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        keyboardIsVisible = true
    }
    
    private func resetUI() {
        keyboardIsVisible = false
        superMarioHeight.constant -= originalYConstraint.constant
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetUI()
        return true
    }
}
