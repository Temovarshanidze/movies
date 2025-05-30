import Foundation

class SearchViewModel {
    
     private let searchmanager = SearchManager()
     let searchService = SearchService()
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
  func fetchMovies(query: String) {
      searchmanager.getMovieDetail(title: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.searchService.searchmovies = movies
            case .failure(let error):
                self?.onError?(error)
            }
          self?.onMoviesUpdated?()
        }
    }
    
    func searchedmovies() -> [Movie] {
        return searchService.searchmovies
    }
    
    var numberOfMovies: Int {
        return searchService.moviesCount
    }
    
    func movie(at index: Int) -> Movie {
        return searchService.movie(at: index)
    }
    
    func sortByTitle() {
        searchService.sortByTitle()
        onMoviesUpdated?()
        
    }
    func sortByReleaseDate() {
        searchService.sortByReleaseDate()
        onMoviesUpdated?()
    }
 
    
     func unsort() {
         searchService.unsort()
        onMoviesUpdated?()
    }
}
