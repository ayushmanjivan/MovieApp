//
//  TMDbService.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import Foundation

class TMDbService {
    static let shared = TMDbService()
    private init() {}
    
    func fetchPopularMovies(page: Int = 1) async throws -> [Movie] {
        let urlString = "\(Config.baseURL)/movie/popular?api_key=\(Config.apiKey)&page=\(page)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(Config.baseURL)/search/movie?api_key=\(Config.apiKey)&query=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return response.results
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        let urlString = "\(Config.baseURL)/movie/\(movieId)?api_key=\(Config.apiKey)&append_to_response=credits"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
        return movieDetail
    }
    
    func fetchMovieVideos(movieId: Int) async throws -> [Video] {
        let urlString = "\(Config.baseURL)/movie/\(movieId)/videos?api_key=\(Config.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(VideosResponse.self, from: data)
        return response.results
    }
}
