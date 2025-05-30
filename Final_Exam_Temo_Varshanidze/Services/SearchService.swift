
import Foundation

class SearchService {
    
     var searchmovies = [Movie]()
    var searchmovies2: [Movie] = []
    
    func update(with movie: [Movie]) {
        self.searchmovies.append(contentsOf: movie)
    }
    
    func movie(at index: Int) -> Movie {
        return searchmovies[index]
    }
    
    var moviesCount: Int {
        return searchmovies.count
    }
    func sortByTitle() {
       searchmovies2 = searchmovies
       searchmovies.sort { $0.title < $1.title }
        
    }
    func sortByReleaseDate() {
        searchmovies.sort { $0.year > $1.year }
    }
 
    
     func unsort() {
         searchmovies = searchmovies2
        
    }
}
