import UIKit

class SearchCell: UICollectionViewCell {

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    private let calendarIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()

    private lazy var releaseDateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [calendarIconView, releaseDateLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
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
        contentView.addSubview(releaseDateStack)
        contentView.addSubview(genreLabel)

        NSLayoutConstraint.activate([
            // პოსტერის ფოტო
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 140),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),

            // სათაური
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            // კალენდარი + თარიღი stackView
            releaseDateStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -15),
            releaseDateStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            genreLabel.topAnchor.constraint(equalTo: releaseDateStack.bottomAnchor, constant: 8),
                    genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                    genreLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.year.isEmpty ? "N/A" : movie.year

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
