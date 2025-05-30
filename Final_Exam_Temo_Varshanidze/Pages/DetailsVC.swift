

import UIKit

class DetailsVC: UIViewController {
    
    private let detailViewModel = DetailViewModel()
    private let viewModel: MoviesViewModel
    private let imdbId: String?
    
    // var isloggedIn: Bool = false
    
    init(viewModel: MoviesViewModel, imdbId: String?) {
        self.viewModel = viewModel
        self.imdbId = imdbId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aboutMovieLabel: UILabel = {
        let label = UILabel()
        label.text = "About Movie"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moviePlotLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel = DetailsVC.makeInfoLabel()
    private let yearIcon = DetailsVC.makeSystemImageView(systemName: "calendar")
    
    private let runtimeLabel = DetailsVC.makeInfoLabel()
    private let runtimeIcon = DetailsVC.makeSystemImageView(systemName: "clock")
    
    private let genreLabel = DetailsVC.makeInfoLabel()
    private let genreIcon = DetailsVC.makeSystemImageView(systemName: "film")
    
    private lazy var infoStack: UIStackView = {
        let yearStack = UIStackView(arrangedSubviews: [yearIcon, yearLabel])
        yearStack.axis = .horizontal
        yearStack.spacing = 4
        
        let runtimeStack = UIStackView(arrangedSubviews: [runtimeIcon, runtimeLabel])
        runtimeStack.axis = .horizontal
        runtimeStack.spacing = 4
        
        let genreStack = UIStackView(arrangedSubviews: [genreIcon, genreLabel])
        genreStack.axis = .horizontal
        genreStack.spacing = 4
        
        let separator1 = DetailsVC.makeSeparator()
        let separator2 = DetailsVC.makeSeparator()
        
        let stack = UIStackView(arrangedSubviews: [yearStack, separator1, runtimeStack, separator2, genreStack])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add star icon + sample rating
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        
        let attributedText = NSMutableAttributedString(attachment: attachment)
        attributedText.append(NSAttributedString(string: " 8.7"))
        label.attributedText = attributedText
        
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
        fetchData()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(handleLoginStatusChange), name: .userDidLogin, object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutStatusChange), name: .userDidLogout, object: nil)
    }
    
    //    @objc private func handleLoginStatusChange() {
    //        print("მომხმარებელი დალოგინდა.")
    //        heartButton.isEnabled = true
    //    }
    //
    //    @objc private func handleLogoutStatusChange() {
    //        print("მომხმარებელი გამოვიდა სისტემიდან.")
    //        heartButton.isEnabled = false
    //    }
    //
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        [posterImageView, movieTitleLabel,ratingLabel, aboutMovieLabel, heartButton, infoStack, moviePlotLabel].forEach {
            view.addSubview($0)
        }
        heartButton.addTarget(self, action: #selector(handleHeartButtonTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            ratingLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -8),
            ratingLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -8),
            ratingLabel.heightAnchor.constraint(equalToConstant: 26),
            ratingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            movieTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            aboutMovieLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 20),
            aboutMovieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            heartButton.centerYAnchor.constraint(equalTo: aboutMovieLabel.centerYAnchor),
            heartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            heartButton.widthAnchor.constraint(equalToConstant: 30),
            heartButton.heightAnchor.constraint(equalToConstant: 30),
            
            infoStack.topAnchor.constraint(equalTo: aboutMovieLabel.bottomAnchor, constant: 12),
            infoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            moviePlotLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
            moviePlotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moviePlotLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Helpers
    
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
    
    private static func makeSeparator() -> UILabel {
        let label = UILabel()
        label.text = "|"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }
    
    // MARK: - Heart Button
    
    @objc private func handleHeartButtonTap() {
        // აქ ფავორიტის დამატების ლოგიკა
        guard let detail = detailViewModel.detailMovie else { return }
        let movie = Movie(from: detail)
        
        if viewModel.favoriteMovies.firstIndex(where: { $0.imdbID == movie.imdbID }) != nil {
            viewModel.removeFavoriteMovie(movie: movie) {
                
            }
        }
        //        else if !viewModel.isloggedIn {
        //            showAlert(message: "Please Login or Signup")
        //        }
        else {
            viewModel.addFavoriteMovie(movie: movie) {
               
            }
        }
        
        // განახლება ღილაკის მდგომარეობის
        updateHeartButtonState(for: movie)
    }
    
    private func updateHeartButtonState(for movie: Movie) {
        let isFavorite = viewModel.favoriteMovies.contains(where: { $0.imdbID == movie.imdbID })
        heartButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    // MARK: - Networking
    
    private func fetchData() {
        detailViewModel.onMoviesUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let movie = self.detailViewModel.detailMovie {
                    self.configure(with: movie)
                    self.setupTitle(with: movie.title)
                }
            }
        }
        
        if let imdbID = imdbId {
            detailViewModel.fetchDetailMovies(imdbID: imdbID)
        }
    }
    
    private func configure(with movie: MovieDetail) {
        movieTitleLabel.text = movie.title
        yearLabel.text = movie.year
        runtimeLabel.text = movie.runtime
        genreLabel.text = movie.genre
        moviePlotLabel.text = movie.plot
        
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        
        let attributedText = NSMutableAttributedString(attachment: attachment)
        attributedText.append(NSAttributedString(string: " \(movie.imdbRating)"))
        ratingLabel.attributedText = attributedText
        
        if let posterPath = movie.poster, posterPath != "N/A", let url = URL(string: posterPath) {
            loadImage(from: url)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func setupTitle(with text: String) {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        navigationItem.titleView = container
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.pushViewController(LogInVC(), animated: true)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}



