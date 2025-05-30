

import UIKit

class LogInVC: UIViewController {
  
    
    let keychain = KeyChainConfig()
    private let viewModel  = MoviesViewModel()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.shield.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username or Email"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(12)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Username or Email",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(12)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()

    private let accountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create New Account", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let forgotButton: UIButton = {
        let button = UIButton(type: .system)
        let attr = NSAttributedString(
            string: "Forgot Password?",
            attributes: [
                .foregroundColor: UIColor.systemGray3,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
        button.setAttributedTitle(attr, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete all Account", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        addButtonTarget()
    }

    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(accountButton)
        view.addSubview(forgotButton)
        view.addSubview(deleteAccountButton)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),

            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            logInButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),

            accountButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 24),
            accountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            forgotButton.topAnchor.constraint(equalTo: accountButton.bottomAnchor, constant: 16),
            forgotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deleteAccountButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 20),
            deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func addButtonTarget() {
        logInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleLogin()
        }), for: .touchUpInside)

        accountButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(CreateVC(), animated: true)
        }), for: .touchUpInside)

        forgotButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(PasswordRecoverVC(), animated: true)
        }), for: .touchUpInside)
        
        deleteAccountButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleDeleteAllAccounts()
        }), for: .touchUpInside)
    }

    @objc private func handleLogin() {
        guard
            let usernameOrEmail = usernameTextField.text, !usernameOrEmail.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            showAlert(message: "Please enter both username/email and password.")
            return
        }

        let accounts = keychain.getAllAccounts(for: "user-registration-service")

        for account in accounts {
            if let data = keychain.get(service: "user-registration-service", account: account),
               let userString = String(data: data, encoding: .utf8) {

                let components = userString.components(separatedBy: ";")
                if components.count == 5 {
                    let firstName = components[0]
                    let lastName = components[1]
                    let username = components[2]
                    let email = components[3]
                    let storedPassword = components[4]

                    if (usernameOrEmail == username || usernameOrEmail == email) && password == storedPassword {
                        let message = "Welcome, \(firstName) \(lastName)!"
                        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.usernameTextField.text = ""
                            self.passwordTextField.text = ""
                            self.navigationController?.pushViewController(ProfileVC(), animated: true)
                        }))
                        viewModel.isloggedIn = true
                        present(alert, animated: true)
                        return
                    }
                }
            }
        }

        showAlert(message: "Invalid username/email or password.")
    }
    
    @objc private func handleDeleteAllAccounts() {
        let accounts = keychain.getAllAccounts(for: "user-registration-service")
        
        if accounts.isEmpty {
            print("ℹ️ No accounts found in Keychain.")
            showAlert(message: "No accounts to delete.")
            return
        }
        
        for account in accounts {
            do {
                try keychain.deletePassword(service: "user-registration-service", account: account)
                print("🗑 Deleted account: \(account)")
            } catch {
                print("❌ Failed to delete account: \(account), error: \(error)")
            }
        }
        
        print("✅ All accounts deleted!")
        showAlert(message: "All accounts have been deleted.")
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }

  
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


