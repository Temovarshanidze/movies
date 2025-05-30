import UIKit

class SearchVC: UIViewController {
    
    private var searchTimer: Timer?
    private let searchviewModel = SearchViewModel()
    private let viewModel: MoviesViewModel
    
    init(viewModel: MoviesViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let filmFindTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search a movie"
        textfield.textColor = .white
        textfield.backgroundColor = .gray
        textfield.borderStyle = .none
        textfield.layer.cornerRadius = 16
        textfield.layer.masksToBounds = true
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search a movie",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.tintColor = .white
        iconImageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        iconContainerView.addSubview(iconImageView)
        textfield.rightView = iconContainerView
        textfield.rightViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        return textfield
    }()
    
    private let pullDownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.clipsToBounds = true
        return button
    }()
    
    private let emptySearchLabel: UILabel = {
        let label = UILabel()
        label.text = "Start typing to search movies..."
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = false
        return label
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No movies found"
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.isHidden = true
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFuncs()
    }
    
    private func callAllFuncs() {
        view.backgroundColor = .black
        titleConfig()
        setupLayout()
        setupPullDownButton()
        filmFindTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
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
        navigationItem.title = "Search "
    }
    
    private func setupLayout() {
        [filmFindTextField, pullDownButton, emptySearchLabel, noResultsLabel, moviesCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            filmFindTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filmFindTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filmFindTextField.trailingAnchor.constraint(equalTo: pullDownButton.leadingAnchor, constant: -10),
            filmFindTextField.heightAnchor.constraint(equalToConstant: 44),
            
            pullDownButton.centerYAnchor.constraint(equalTo: filmFindTextField.centerYAnchor),
            pullDownButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pullDownButton.widthAnchor.constraint(equalToConstant: 44),
            pullDownButton.heightAnchor.constraint(equalToConstant: 44),
            
            emptySearchLabel.topAnchor.constraint(equalTo: filmFindTextField.bottomAnchor, constant: 20),
            emptySearchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noResultsLabel.topAnchor.constraint(equalTo: filmFindTextField.bottomAnchor, constant: 20),
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            moviesCollectionView.topAnchor.constraint(equalTo: filmFindTextField.bottomAnchor, constant: 10),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
    }
    
    private func setupPullDownButton() {
        let nameSort = UIAction(title: "Name") { [weak self] _ in
            self?.searchviewModel.sortByTitle()}
        let yearSort = UIAction(title: "Year") { [weak self] _ in
            self?.searchviewModel.sortByReleaseDate()}
        let Unsort = UIAction(title: "Unsort") { [weak self] _ in
            self?.searchviewModel.unsort()}
        let menu = UIMenu(title: "Sort By", children: [nameSort, yearSort, Unsort])
        pullDownButton.menu = menu
        pullDownButton.showsMenuAsPrimaryAction = true
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        // ძველი ტაიმერი გავაუქმოთ, რომ ახალზე გადავიდეს (თითოეულ ასოზე ახალი ტაიმერი არ გაეშვას)
        searchTimer?.invalidate()
        
        // თუ ტექსტი ცარიელია ან მხოლოდ space-ებია
        guard let text = filmFindTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            // ვასუფთავებთ ძველ ფილმების სიას
            searchviewModel.searchService.searchmovies = []
            // ვანახლებთ ცარიელ კოლექშენს
            moviesCollectionView.reloadData()
            
            // ვაჩვენებთ ლეიბელს "Start typing to search..."
            emptySearchLabel.isHidden = false
            // ვმალავთ "No movies found"-ს
            noResultsLabel.isHidden = true
            // ვმალავთ კოლექშენვიუს
            moviesCollectionView.isHidden = true
            return
        }

        // ტექსტია შეყვანილი — დავმალოთ ყველაფერი სანამ ახალ შედეგს ველოდებით
        emptySearchLabel.isHidden = true
        noResultsLabel.isHidden = true
        moviesCollectionView.isHidden = true

        // 0.5 წამით ვაცადოთ, რომ ყოველ ასოზე არ გაეშვას API
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            // წამოიღოს ფილმები შეყვანილი ტექსტით
            self.searchviewModel.fetchMovies(query: text)
            
            // შედეგის მიღებისას...
            self.searchviewModel.onMoviesUpdated = { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // წაკითხული ფილმების რაოდენობა
                    let movies = self.searchviewModel.searchedmovies()
                    
                    // თუ სია ცარიელია → აჩვენე "No movies found"
                    if movies.isEmpty {
                        self.moviesCollectionView.isHidden = true
                        self.noResultsLabel.isHidden = false
                    } else {
                        // თუ სია არის → აჩვენე კოლექშენვიუ
                        self.moviesCollectionView.isHidden = false
                        self.noResultsLabel.isHidden = true
                    }

                    // როგორ შემთხვევაშიც არ უნდა ვიყოთ, "Start typing" ტექსტი დაიმალოს
                    self.emptySearchLabel.isHidden = true
                    // განახლდეს კოლექშენვიუ
                    self.moviesCollectionView.reloadData()
                }
            }
        }
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchviewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let movie = searchviewModel.movie(at: indexPath.row)
        cell.configure(with: movie)
        return cell
    }
    
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        return CGSize(width: width, height: 160)
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = searchviewModel.movie(at: indexPath.row)
        print("Selected movie IMDb ID: \(movie.imdbID)")
        print(movie.year)
        let detailVC = DetailsVC(viewModel: viewModel, imdbId: movie.imdbID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
  
}
