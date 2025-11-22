//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadMovieDetails(movieId: Int) async {
        isLoading = true
        errorMessage = nil
        async let detailTask = TMDbService.shared.fetchMovieDetails(movieId: movieId)
        async let videosTask = TMDbService.shared.fetchMovieVideos(movieId: movieId)
        do {
            let (detail, videos) = try await (detailTask, videosTask)
            self.movieDetail = detail
            self.videos = videos.filter { $0.type == "Trailer" && $0.site == "YouTube" }
        } catch {
            errorMessage = "Failed to load details: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    var trailerVideo: Video? {
        videos.first { $0.official } ?? videos.first
    }
}
