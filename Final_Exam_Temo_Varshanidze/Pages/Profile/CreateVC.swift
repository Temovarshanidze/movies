import UIKit

class CreateVC: UIViewController {

    let keychain = KeyChainConfig()
    var isChecked = false
   // weak var delegate: FullNameChangeDelegate?
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "First Name",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints2(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Last Name",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints2(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints2(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints2(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter Password",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.layer.cornerRadius = 8
        textField.isSecureTextEntry = true
        textField.setLeftPaddingPoints2(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Repeat Password"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Repeat Password",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.layer.cornerRadius = 8
        textField.isSecureTextEntry = true
        textField.setLeftPaddingPoints2(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        return button
    }()
    
    let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "By signing up, you agree to our"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let privacePolicyButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSAttributedString(string: "Privacy&Policy", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: 1.0
        ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let checkboxButton: UIButton = {
        let button = UIButton()
        button.setTitle("☐", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFunction()
    }
    
    func callAllFunction() {
        view.backgroundColor = .black
        setUpUi()
        setUpButtons()
    }
    
    func setUpUi() {
        [firstNameTextField, lastNameTextField, usernameTextField, emailTextField, passwordTextField, repeatPasswordTextField, checkboxButton, privacyLabel, privacePolicyButton, createButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 12),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            usernameTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 12),
            usernameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            checkboxButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 14),
            checkboxButton.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            
            privacyLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
            privacyLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            
            privacePolicyButton.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
            privacePolicyButton.leadingAnchor.constraint(equalTo: privacyLabel.trailingAnchor, constant: 4),
            
            createButton.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 28),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 140),
            createButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setUpButtons() {
        privacePolicyButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(PrivacyAndPolicyVC(), animated: true)
        }), for: .touchUpInside)
        
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        
        createButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            if !self.isChecked {
                self.showAlert(message: "Please mark the checkbox.")
                return
            }
            self.saveUserDataToKeychain()
        }), for: .touchUpInside)
    }
    
    func saveUserDataToKeychain() {
        guard
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = repeatPasswordTextField.text, !confirmPassword.isEmpty
        else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }

        if let _ = keychain.get(service: "user-registration-service", account: username) {
            showAlert(message: "User already exists.")
            return
        }

        let credentials = "\(firstName);\(lastName);\(username);\(email);\(password)"
        guard let data = credentials.data(using: .utf8) else { return }

        do {
            try keychain.save(service: "user-registration-service", account: username, password: data)
            let alert = UIAlertController(title: "✅", message: "Account Created Successfully", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                //let fullname = firstName + " " + lastName
              //  self.delegate?.changeFullName(fullname: fullname, username: username)
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        } catch {
            print("🔴 Error saving to Keychain: \(error)")
            showAlert(message: "Failed to save credentials.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func toggleCheckbox(sender: UIButton) {
        isChecked.toggle()
        sender.setTitle(isChecked ? "☑" : "☐", for: .normal)
    }
}

// MARK: - UITextField Extension for Padding
extension UITextField {
    func setLeftPaddingPoints2(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
