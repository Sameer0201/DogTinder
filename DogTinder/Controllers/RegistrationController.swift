//
//  RegistrationController.swift
//  DogTinder
//
//  Created by Nagasaki on 03/03/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.selectPhotoButton.setImage(image, for: .normal)
        registrationViewModel.bindableImage.value = image
        //        registrationViewModel.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

class RegistrationController: UIViewController {

    // UI components
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        
        //select photo title
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        
        //set background color of photo to white
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        
        //make the photo select button a box
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        return button
    }()
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter password"
        // doesnt show autofill text
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        
        //color of the background
        //button.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister(){
        self.handleTapDismiss()
        
        registrationViewModel.performRegistration { [weak self] (err) in
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
            print("Finished registering our user")
        }
    }
    
    fileprivate func showHUDWithError(error: Error){
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    // lazy cuz it on on the outside of the layout
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])
    
    //method changes the layout from horizontal to vertical vis-vic
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        
        // set up observers to see keyboard open and hide
        setupNotificationObservers()
        
        setupTapGesture()
        
        setupRegistrationViewModelObserver()
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver(){
        //unknown self to avoid retain cycle
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            self.registerButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        registrationViewModel.bindableImage.bind { [unowned self] (img) in self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true) // dismiss keyboard
    }
    
    fileprivate func setupNotificationObservers(){
        // to show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // to hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // to remove to observers when the view task is completed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self) // you'll have a retain cycle
    }
    
    //
    
    @objc fileprivate func handleKeyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification){
        // how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        // let's try to figure out how tall the gap is from the register button to the bottom of the screen
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        
        //move the frame the height of the keyboard up
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer(){
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
        
    }
}
