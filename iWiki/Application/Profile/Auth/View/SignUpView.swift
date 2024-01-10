//
//  SignUpView.swift
//  iWiki
//
//  Created by Максим Бойчук on 19.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class SignUpView: UIViewController {
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var locationTextField: UITextField?
    @IBOutlet weak var usernameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var errorLabel: UILabel?
    
    @IBOutlet weak var scrollView: UIScrollView?
    private var activeTextField: UITextField?
    
    private var viewModel: SignUpViewModel?
    
    @IBAction func signUpButton(_ sender: UIButton) {
        signUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        guard let errorLabel = errorLabel, let nameTextField = nameTextField, let locationTextField = locationTextField,
            let usernameTextField = usernameTextField, let passwordTextField = passwordTextField else {
                return
        }
        
        errorLabel.alpha = 0
        nameTextField.delegate = self
        locationTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        viewModel = SignUpViewModel()
    }
    
    private func signUp() {
        guard let name = nameTextField?.text, let location = locationTextField?.text, let viewModel = viewModel,
            let username = usernameTextField?.text, let password = passwordTextField?.text else {
                showError(message: "null objects")
                return
        }
        
        if (name.isEmpty || location.isEmpty || username.isEmpty || password.isEmpty) {
            showError(message: "Not all fields are filled in")
            return
        }
        
        let hashedPassword = password.md5()
        let user = User(username: username, password: hashedPassword, name: name, location: location)
        viewModel.signUp(user, completion: { [weak self] (status) in
            guard let self = self else { return }
            if let errorMessage = self.handleError(status: status) {
                self.showError(message: errorMessage)
            } else {
                let signInView = SignInView()
                signInView.modalPresentationStyle = .fullScreen
                self.present(signInView, animated: true, completion: nil)
            }
        })
    }
    
    func showError(message: String) {
        guard let errorLabel = errorLabel else {
            return
        }
        errorLabel.textAlignment = .center
        errorLabel.text = message
        errorLabel.alpha = 1.0
        errorLabel.layer.cornerRadius = 16;
        errorLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 4.0, options: .curveEaseOut, animations: {
            errorLabel.alpha = 0.0
        })
    }
}

extension SignUpView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let activeTextField = activeTextField else { return true }
        activeTextField.resignFirstResponder()
        self.activeTextField = nil
        return true
    }
}

extension SignUpView {
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardFunc))
        guard let scrollView = scrollView else { return }
        scrollView.addGestureRecognizer(hideKeyboard)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let info = notification.userInfo,
            let keyboardRect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardSize = keyboardRect.size
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        guard let scrollView = scrollView else { return }
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        guard let activeTextField = activeTextField else { return }
        let scrollPoint = CGPoint(x: 0, y: activeTextField.frame.origin.y - keyboardSize.height)
        scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        guard let scrollView = scrollView else { return }
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func hideKeyboardFunc() {
        guard let scrollView = scrollView else { return }
        scrollView.endEditing(true)
    }
}

extension SignUpView {
    private func handleError(status: iWikiClient.Status) -> String? {
        switch status {
        case .OK:
            return nil
        case .BadRequest:
            return "Bad request. Try again."
        case .Unauthorized:
            return "Unathorized request."
        case .Conflict:
            return "This username already exists."
        case .InternalError:
            return "Internal server error. Try again."
        case .Unreachable:
            return "Server is not available. Try again."
        case .UnknownError:
            return "Unknown error occurred. Try again."
        default:
            print(status)
            return "???"
        }
    }
}
