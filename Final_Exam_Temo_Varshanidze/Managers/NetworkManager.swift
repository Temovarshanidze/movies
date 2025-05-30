import Foundation

enum NetworkManagerError: Error {
    case wrongResponse
    case statusCodeError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>( urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response1 = response as? HTTPURLResponse else {
                completion(.failure(NetworkManagerError.wrongResponse))
                return
            }
            
            guard(200...299).contains(response1.statusCode) else {
                completion(.failure(NetworkManagerError.statusCodeError))
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
                
            } catch {
                completion(.failure(error))
                
            }
            
        }.resume()
    }
}
