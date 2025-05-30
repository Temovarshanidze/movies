

import UIKit

class PrivacyAndPolicyVC: UIViewController {
let ragacaLabel: UILabel = {
        let label = UILabel()
        label.text = "piroba 1"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ragacaLabel1: UILabel = {
            let label = UILabel()
            label.text = "piroba 2"
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let ragacaLabel2: UILabel = {
            let label = UILabel()
            label.text = "piroba 3"
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let ragacaLabel3: UILabel = {
            let label = UILabel()
            label.text = "piroba 4"
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFunction()
    }
    
    func callAllFunction(){
        view.backgroundColor = .cyan
        setUpUI()
    }
    func setUpUI(){
        view.addSubview(ragacaLabel)
        view.addSubview(ragacaLabel1)
        view.addSubview(ragacaLabel2)
        view.addSubview(ragacaLabel3)
        
        NSLayoutConstraint.activate([
            
            ragacaLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 20),
            ragacaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ragacaLabel1.topAnchor.constraint(equalToSystemSpacingBelow: ragacaLabel.topAnchor, multiplier: 20),
            ragacaLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ragacaLabel2.topAnchor.constraint(equalToSystemSpacingBelow: ragacaLabel1.topAnchor, multiplier: 20),
            ragacaLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ragacaLabel3.topAnchor.constraint(equalToSystemSpacingBelow: ragacaLabel2.topAnchor, multiplier: 20),
            ragacaLabel3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
        ])
    }
    
}
