
import Foundation

class DetailViewModel {
    private let detailmanager = DetailManager()
    var detailMovie: MovieDetail?
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
 
     func fetchDetailMovies(imdbID: String) {
         detailmanager.getMovieDetail(imdbID: imdbID) { [weak self ] result in
            
            switch result {
            case.success(let detailMovie):
                self?.detailMovie = detailMovie
               // print(detailMovie.title)
                self?.onMoviesUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription as! Error)
            }
        }
        
    }
    
    func returnTitle() -> String {
        return detailMovie?.title ?? "Title Not Found"
    }
}
