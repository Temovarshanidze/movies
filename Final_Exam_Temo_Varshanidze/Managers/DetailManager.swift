

import Foundation

final class DetailManager: MovieDetailDelegate {
    
    static let shared = DetailManager()
    
    init() {}
    
    func getMovieDetail(imdbID:String, completion: @escaping (Result<MovieDetail, any Error>) -> Void) {
        let apikey = "fd67c604"
        let urlString = "https://www.omdbapi.com/?apikey=\(apikey)&i=\(imdbID)"
        
        NetworkManager.shared.fetchData(urlString: urlString) { (result: Result<MovieDetail, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
