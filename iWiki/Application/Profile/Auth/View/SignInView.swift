//
//  SignInView.swift
//  iWiki
//
//  Created by Максим Бойчук on 19.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class SignInView: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var errorLabel: UILabel?
    
    @IBOutlet weak var scrollView: UIScrollView?
    private var activeTextField: UITextField?
    
    private var viewModel: SignInViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        guard let errorLabel = errorLabel, let usernameTextField = usernameTextField,
            let passwordTextField = passwordTextField else {
                return
        }
        
        errorLabel.alpha = 0
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        viewModel = SignInViewModel()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func goToSignUpScreen(_ sender: UIButton) {
        let signUpView = SignUpView()
        present(signUpView, animated: true, completion: nil)
    }
    
    private func signIn() {
        guard let username = usernameTextField?.text, let password = passwordTextField?.text,
            let viewModel = viewModel else {
                showError(message: "null objects")
                return
        }
        
        if (username.isEmpty || password.isEmpty) {
            showError(message: "Not all fields are filled in")
            return
        }
        
        let hashedPassword = password.md5()
        let user = User(username: username, password: hashedPassword)
        viewModel.signIn(user, completion: { [weak self] (status, userData) in
            guard let self = self else { return }
            if let errorMessage = self.handleError(status: status) {
                self.showError(message: errorMessage)
            } else {
                
                /*print(userData)
                let object = try? JSONDecoder().decode(User.self, from: userData!)
                print(object ?? nil)*/
                
                /*let obj = try? JSONSerialization.jsonObject(with: userData!, options: []) as? User
                print(obj ?? "kek")*/
                
                /*let objj = String(bytes: [UInt8](userData!), encoding: .utf8)
                print(objj)
                print(Data(objj!.utf8))
                
                let obj = try? JSONDecoder().decode(User.self, from: Data([UInt8](userData!)))
                print(obj)*/
                
                guard let userData = userData/*, let userJson = String(bytes: [UInt8](userData), encoding: .utf8)*/,
                    let userObject = try? JSONDecoder().decode(User.self, from: userData),
                    (try? UserDefaults.standard.setObject(userObject, forKey: "CurrentUser")) != nil
                    else {
                        self.showError(message: "Failed to save data. Try again.")
                        return
                }
                print(userObject)
                let profileView = ProfileView()
                //profileView.modalPresentationStyle = .fullScreen
                self.present(profileView, animated: true, completion: nil)
            }
        })
    }
}

extension SignInView: UITextFieldDelegate {
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

extension SignInView {
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

extension SignInView {
    private func handleError(status: iWikiClient.Status) -> String? {
        switch status {
        case .OK:
            return nil
        case .BadRequest:
            return "Bad request. Try again."
        case .Unauthorized:
            return "Unathorized request."
        case .NotFound:
            return "This username was not found."
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
