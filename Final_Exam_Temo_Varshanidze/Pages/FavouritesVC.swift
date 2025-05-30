import UIKit

class FavouritesVC: UIViewController {

    private let viewModel: MoviesViewModel
    private let movieService = MovieService()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    // Label to display when there are no favorites
    private let noFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Initially hidden
        return label
    }()
    
    // Additional label for the second message
    private let noFavoritesDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "All movies as favorite will be added here"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Initially hidden
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFuncs()
    }
    
    private func callAllFuncs() {
        view.backgroundColor = .black
        titleConfig()
        setupUI()
        fetchData()
        
        labelConfigure()
    }
    
    private func titleConfig() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Favorites"
    }
    
    private func fetchData() {
     //   viewModel.fetchMovies()
        viewModel.onMoviesFavoritUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
                self?.labelConfigure()
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(moviesCollectionView)
        view.addSubview(noFavoritesLabel)
        view.addSubview(noFavoritesDescriptionLabel)
        
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            moviesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            moviesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            noFavoritesDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesDescriptionLabel.topAnchor.constraint(equalTo: noFavoritesLabel.bottomAnchor, constant: 10)
        ])
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "MoviesCell")
        
        if let layout = moviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.width - 30) / 3
            layout.itemSize = CGSize(width: width, height: width * 1.7)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
    }
    
    private func labelConfigure() {
        
        if  self.viewModel.numberOfFavoriteMovies > 0 {
            self.noFavoritesLabel.isHidden = true
            self.noFavoritesDescriptionLabel.isHidden = true
        }else {
            self.noFavoritesLabel.isHidden = false
            self.noFavoritesDescriptionLabel.isHidden = false
        }
    }
}

extension FavouritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFavoriteMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        let movie = viewModel.favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3
        let height = width * 1.7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.favoriteMovies[indexPath.row]
        let detailVC = DetailsVC(viewModel: viewModel, imdbId: movie.imdbID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
