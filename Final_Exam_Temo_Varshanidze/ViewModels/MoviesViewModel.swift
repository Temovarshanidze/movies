import Foundation

class MoviesViewModel {
    
  //  private let movieManager = MovieManager()
    private let movieService = MovieService()
    private let movieDelegate: MoviesDelegate
    
    var onMoviesUpdated: (() -> Void)?
    var onMoviesFavoritUpdated :(() -> Void)?
    var onError: ((Error) -> Void)?
    var  isloggedIn:Bool = false
    
   // var movies: [Movie] = []
    var favoriteMovies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 1
    private var detailViewModel: DetailViewModel?
    init(movieDelegate: MoviesDelegate = MovieManager(), detailViewModel: DetailViewModel? = nil) {
           self.movieDelegate = movieDelegate
           self.detailViewModel = detailViewModel
       }
    
    func fetchMovies() {
        fetchNextPage()
    }
    
    private func fetchNextPage() {
        guard currentPage <= totalPages else { return }
       // print(currentPage)
        
        movieDelegate.getMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let movies):
              //  self?.movies.append(contentsOf: movies) // აქ ხდება ყოველ შემდეგ გვერდზე არსებული ფილმეის დმატება ერეიში
                self?.movieService.update(with: movies)
                //self?.movieService.movies.append(contentsOf: movies)
                self?.currentPage += 1 // ყოველი შემდეგი ფეიჯი
                
                
                self?.totalPages = 30 // ზედა ზღვარი ფეიჯების რაოდენობის. ეს ზღვარი ჩემით დავუწესე :დ
                self?.onMoviesUpdated?()
                
                
                self?.fetchNextPage() // ანუ ეს თავიდან იძახებს თავისთავს რომ მოხდეს ყვეალ ფეიჯის ჩატვირთვა, ანუ  27 ხაზზე ხდება 1 ით გაზრდა გვერდების
                
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    var numberOfMovies: Int {
        return movieService.moviesCount
    }

    func movie(at index: Int) -> Movie {
        return movieService.movie(at: index)
    }
    
    
    func addFavoriteMovie(movie: Movie, completion: @escaping () -> Void) {
        if !favoriteMovies.contains(where: { $0.imdbID == movie.imdbID }) {
            favoriteMovies.append(movie)
             print(favoriteMovies.count)
            self.onMoviesFavoritUpdated?()
        }else {
            completion()
        }
    }
    
    func removeFavoriteMovie(movie: Movie, completion: @escaping () -> Void) {
        if let index = favoriteMovies.firstIndex(where: { $0.imdbID == movie.imdbID }) {
            favoriteMovies.remove(at: index)
            print(favoriteMovies.count)
            self.onMoviesFavoritUpdated?()
        } else {
            completion()
        }
    }
    
    
    var numberOfFavoriteMovies: Int {
        return favoriteMovies.count
    }
}
