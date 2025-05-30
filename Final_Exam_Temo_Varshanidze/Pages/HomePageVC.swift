import UIKit

class HomePageVC: UIViewController {
    
    private let viewModel: MoviesViewModel
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFuncs()
    }
    
    private func callAllFuncs() {
        view.backgroundColor = .black
        titleConfig()
        setupUI()
        fetchData()
    }
    private func titleConfig() {
        // თეთრი დიდი სათაურისთვის კონფიგურაცია
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black // შეცვალე ფონი სურვილისამებრ
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // ჩვეულებრივი title
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // დიდი title
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // თვითონ სათაური
        navigationItem.largeTitleDisplayMode = .always // ანუ მარტო დიდი ასოებინი ჩანს 
        navigationItem.title = "Movies"
    }
    
    private func fetchData() {
        viewModel.fetchMovies()
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(moviesCollectionView)
        
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            moviesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            moviesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "MoviesCell")
        
        // Update layout for 3 items in a row
        if let layout = moviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.width - 20) / 3 // spacing adjustment (left + right padding)
            layout.itemSize = CGSize(width: width, height: width * 1.5) // height ratio (adjust as needed)
            layout.minimumInteritemSpacing = 10 // Space between items horizontally
            layout.minimumLineSpacing = 10 // Space between rows vertically
        }
    }
}


extension HomePageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        let movies = viewModel.movie(at: indexPath.row)
        cell.configure(with: movies)
        return cell
    }
    // ეს ფუნქცია განსაზღვრავს თითოეული ელემენტის ზომას
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3 // მაგალითად, 3 ელემენტი გვერდზე
        let height = width * 1.7 // პოსტერების პროპორციული ზომა, იგივე პროპორცია რაც შენ გააკეთე
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath.row)
        print("Selected movie IMDb ID: \(movie.imdbID)")
        print(movie.year)
        let detailVC = DetailsVC(viewModel: viewModel, imdbId: movie.imdbID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}


