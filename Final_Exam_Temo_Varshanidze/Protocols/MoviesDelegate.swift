import UIKit
import Foundation

protocol MoviesDelegate {
    func getMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}

protocol MovieDetailDelegate {
    func getMovieDetail( imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void)
}


protocol MovieSearchDelegate {
    func getMovieDetail( title: String, completion: @escaping (Result<[Movie], Error>) -> Void)
}


protocol MovieAddDelegate: AnyObject {
    func addMovie(cell : MoviesCell)
}


protocol FullNameChangeDelegate: AnyObject {
    func changeFullName(fullname: String, username: String)
}
