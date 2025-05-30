import UIKit

final class MoviesCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail // თუ ტექსტი გრძელია და არ ეტევა ... სახით ამოკლებს
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            posterImageView.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
       
        
             
        ])
        
    }
    
    private static func makeInfoLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private static func makeSystemImageView(systemName: String) -> UIImageView {
        let iv = UIImageView(image: UIImage(systemName: systemName))
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 14).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return iv
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
      //  print("Title: \(titleLabel.text ?? "No title")") // Make sure title is being set
        if let posterPath = movie.poster, posterPath != "N/A" {
            loadImage(from: posterPath)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            } else {
                print("Failed to load image from \(urlString)")
            }
        }.resume()
    }
}


