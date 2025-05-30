

import Foundation

final class SearchManager: MovieSearchDelegate {
    static let shared = SearchManager()
    
    init() {}
    func getMovieDetail(title: String, completion: @escaping (Result<[Movie], any Error>) -> Void) {
        let apikey = "fd67c604"
        let urlString = "https://www.omdbapi.com/?apikey=\(apikey)&s=\(title)&type=movie&page=1"
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
