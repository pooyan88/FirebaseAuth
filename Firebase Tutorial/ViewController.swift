//
//  ViewController.swift
//  Firebase Tutorial
//
//  Created by Pooyan J on 11/3/1402 AP.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log in"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let emailField: UITextField = {
        let emailField  = UITextField()
        emailField.placeholder = "Enter your email"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()
    
    private let passField: UITextField = {
        let passField  = UITextField()
        passField.placeholder = "Enter your password"
        passField.isSecureTextEntry = true
        passField.layer.borderWidth = 1
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passField.layer.borderColor = UIColor.black.cgColor
        return passField
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        emailField.delegate = self
        passField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40,
                                  height: 50)
        passField.frame = CGRect(x: 20,
                                 y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                 width: view.frame.size.width-40,
                                 height: 50)
        button.frame = CGRect(x: 20,
                              y: passField.frame.origin.y+passField.frame.size.height+10,
                              width: view.frame.size.width-40,
                              height: 50)

    }

    @objc private func didTapButton() {
            let email = emailField.text!
            let password = passField.text!
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                guard let self else { return }
                guard error == nil else {
                    // show account creation
                    showCreateAccount(email: email, password: password)
                    return
            }
            print("you have signed in")
                label.isHidden = true
                emailField.isHidden = true
                passField.isHidden = true
                button.isHidden = true
        }
    }
}

//MARK: - Actions
extension ViewController {
    
    // Get auth instance
    // attempt sign in
    // if failure, present alert to create account
    // if user continues, create account
    
    // check sign in on app launch
    // allow user to sign out with button
    private func isFieldValid()-> Bool {
        if let email = emailField.text , let password = passField.text {
            return !email.isEmpty && !password.isEmpty
        }
       return false
    }
    
    private func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Continue", style: .default) { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self else { return }
                guard error == nil else {
                    // show account creation
                    print("account creation failed")
                    return
            }
            print("you have signed in")
                label.isHidden = true
                emailField.isHidden = true
                passField.isHidden = true
                button.isHidden = true
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

//MARK: - Delegates
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        button.isEnabled = isFieldValid()
    }
}
