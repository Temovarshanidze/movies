

import Foundation

// MovieResponse-ი უნდა იყოს Codable, რადგან გადმოსაცემია JSON-ი
struct MovieResponse: Codable {
    let search: [Movie] 
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String?
    //let plot: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
       // case plot = "Plot"
    }
}

extension Movie {
    init(from detail: MovieDetail) {
        self.title = detail.title
        self.year = detail.year
        self.imdbID = detail.imdbID
        self.type = detail.type
        self.poster = detail.poster
        
    }
}
