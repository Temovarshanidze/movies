import UIKit

class PasswordRecoverVC: UIViewController {
    
    // 📩 ტექსტფილდი იუზერნეიმისთვის ან იმეილისთვის
    private let recoveryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1) // გამჭვირვალე ნაცრისფერი
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter email",
            attributes: [.foregroundColor: UIColor.lightGray])
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints1(12)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 🔁 reset ღილაკი
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 🎬 მთავარი ლოდერი
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEverything()
    }
    
    // 🎯 საერთო ფუნქცია
    private func setupEverything() {
        view.backgroundColor = .black // შავი ფონი
        setupUI()
        setupButtonAction()
    }

    // 🧱 ელემენტების განლაგება
    private func setupUI() {
        view.addSubview(recoveryTextField)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            recoveryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            recoveryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            recoveryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            recoveryTextField.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: recoveryTextField.bottomAnchor, constant: 40),
            resetButton.leadingAnchor.constraint(equalTo: recoveryTextField.leadingAnchor),
            resetButton.trailingAnchor.constraint(equalTo: recoveryTextField.trailingAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // 🧠 ღილაკზე მოქმედება
    private func setupButtonAction() {
        resetButton.addAction(UIAction(handler: { [weak self] _ in
            let alert = UIAlertController(
                title: "Message",
                message: "Temporary password has been sent to your email",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }), for: .touchUpInside)
    }
}

// ➕ Padding Extension (თუ ჯერ არ გაქვს გლობალურად)
extension UITextField {
    func setLeftPaddingPoints1(_ amount: CGFloat) {
        let paddingView = UIView()
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        self.leftView = paddingView
        self.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            paddingView.widthAnchor.constraint(equalToConstant: amount)
        ])
    }
}
