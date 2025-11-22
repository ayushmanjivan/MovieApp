//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import Foundation

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    private var allMovies: [Movie] = []
    private var currentPage = 1
    private var isLoadingMore = false
    private var canLoadMore = true
    
    func loadPopularMovies() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        canLoadMore = true
        do {
            let fetchedMovies = try await TMDbService.shared.fetchPopularMovies(page: currentPage)
            movies = fetchedMovies
            allMovies = fetchedMovies
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func loadMoreMoviesIfNeeded(currentMovie: Movie) async {
        guard !isLoadingMore, canLoadMore, searchQuery.isEmpty else { return }
        guard let currentIndex = movies.firstIndex(where: { $0.id == currentMovie.id }),
              currentIndex >= movies.count - 5 else { return }
        await loadMoreMovies()
    }
    
    private func loadMoreMovies() async {
        isLoadingMore = true
        currentPage += 1
        do {
            let newMovies = try await TMDbService.shared.fetchPopularMovies(page: currentPage)
            if newMovies.isEmpty {
                canLoadMore = false
            } else {
                movies.append(contentsOf: newMovies)
                allMovies.append(contentsOf: newMovies)
            }
        } catch {
            currentPage -= 1
            errorMessage = "Failed to load more movies: \(error.localizedDescription)"
        }
        isLoadingMore = false
    }
    
    func searchMovies() async {
        guard !searchQuery.isEmpty else {
            movies = allMovies
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let searchResults = try await TMDbService.shared.searchMovies(query: searchQuery)
            movies = searchResults
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func resetSearch() {
        searchQuery = ""
        movies = allMovies
    }
}
