
import Foundation

final class MovieManager: MoviesDelegate {
    static let shared = MovieManager()
    
    init() {}

    func getMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        //let searchTerm = "peaky" // ზოგადი ასო, რომ "ყველა" წამოიღოს
        let apikey = "fd67c604"
        let urlString = "https://www.omdbapi.com/?apikey=\(apikey)&s=woman&type=movie&page=\(page)"
        
        NetworkManager.shared.fetchData(urlString: urlString) { (result: Result<MovieResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data.search))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

