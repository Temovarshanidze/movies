

import Foundation

class MovieService {
    
     var movies = [Movie]()
    
    func update(with movie: [Movie]) {
        self.movies.append(contentsOf: movie)
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    var moviesCount: Int {
        return movies.count
    }

}
// ვცადე რომ გადამეყვანა Single Responsibility Principle (SRP) - ზე
