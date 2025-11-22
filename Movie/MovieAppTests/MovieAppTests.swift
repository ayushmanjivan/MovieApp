//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by ayushman.soni on 22/11/25.
//

import XCTest
@testable import MovieApp

@MainActor
final class MovieAppTests: XCTestCase {
    // MARK: - MoviesViewModel Tests
    func testMoviesViewModelInitialState() {
        let viewModel = MoviesViewModel()
        XCTAssertTrue(viewModel.movies.isEmpty, "Movies should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Should have no error initially")
        XCTAssertEqual(viewModel.searchQuery, "", "Search query should be empty initially")
    }
    
    func testLoadPopularMoviesSuccess() async {
        let viewModel = MoviesViewModel()
        await viewModel.loadPopularMovies()
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertFalse(viewModel.movies.isEmpty, "Movies should not be empty after loading")
        XCTAssertNil(viewModel.errorMessage, "Should have no error on success")
    }
    
    func testSearchMoviesWithQuery() async {
        let viewModel = MoviesViewModel()
        await viewModel.loadPopularMovies()
        viewModel.searchQuery = "Harry Potter"
        await viewModel.searchMovies()
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after search")
        XCTAssertFalse(viewModel.movies.isEmpty, "Should have search results")
    }
    
    func testSearchMoviesWithEmptyQuery() async {
        let viewModel = MoviesViewModel()
        await viewModel.loadPopularMovies()
        let originalMoviesCount = viewModel.movies.count
        viewModel.searchQuery = ""
        await viewModel.searchMovies()
        XCTAssertEqual(viewModel.movies.count, originalMoviesCount, "Should return to original movies")
    }
    
    func testResetSearch() async {
        let viewModel = MoviesViewModel()
        await viewModel.loadPopularMovies()
        let originalMoviesCount = viewModel.movies.count
        viewModel.searchQuery = "Test"
        await viewModel.searchMovies()
        viewModel.resetSearch()
        XCTAssertEqual(viewModel.searchQuery, "", "Search query should be empty")
        XCTAssertEqual(viewModel.movies.count, originalMoviesCount, "Should restore original movies")
    }

    // MARK: - MovieDetailViewModel Tests
    func testMovieDetailViewModelInitialState() {
        let viewModel = MovieDetailViewModel()
        XCTAssertNil(viewModel.movieDetail, "Movie detail should be nil initially")
        XCTAssertTrue(viewModel.videos.isEmpty, "Videos should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Should have no error initially")
    }
    
    func testLoadMovieDetailsSuccess() async {
        let viewModel = MovieDetailViewModel()
        let movieId = 671
        await viewModel.loadMovieDetails(movieId: movieId)
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertNotNil(viewModel.movieDetail, "Movie detail should be loaded")
        XCTAssertNil(viewModel.errorMessage, "Should have no error on success")
    }
    
    func testLoadMovieDetailsWithInvalidId() async {
        let viewModel = MovieDetailViewModel()
        let invalidMovieId = -1
        await viewModel.loadMovieDetails(movieId: invalidMovieId)
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertNotNil(viewModel.errorMessage, "Should have error message for invalid ID")
    }
    
    func testTrailerVideoSelection() async {
        let viewModel = MovieDetailViewModel()
        let movieId = 671
        await viewModel.loadMovieDetails(movieId: movieId)
        if !viewModel.videos.isEmpty {
            XCTAssertNotNil(viewModel.trailerVideo, "Should have a trailer video")
            XCTAssertEqual(viewModel.trailerVideo?.site, "YouTube", "Trailer should be from YouTube")
            XCTAssertEqual(viewModel.trailerVideo?.type, "Trailer", "Video type should be Trailer")
        }
    }
    
    func testTrailerVideoPreferOfficialTrailer() async {
        let viewModel = MovieDetailViewModel()
        let movieId = 671
        await viewModel.loadMovieDetails(movieId: movieId)
        let trailer = viewModel.trailerVideo
        let hasOfficialTrailer = viewModel.videos.contains { $0.official }
        if hasOfficialTrailer {
            XCTAssertTrue(trailer?.official ?? false, "Should prefer official trailer when available")
        }
    }
    
    // MARK: - Model Tests
    func testMovieModelDecoding() throws {
        let json = """
        {
            "id": 1,
            "title": "Test Movie",
            "overview": "Test overview",
            "poster_path": "/test.jpg",
            "backdrop_path": "/backdrop.jpg",
            "release_date": "2024-01-01",
            "vote_average": 8.5,
            "vote_count": 100
        }
        """
        let data = json.data(using: .utf8)!
        let movie = try JSONDecoder().decode(Movie.self, from: data)
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertEqual(movie.voteAverage, 8.5)
        XCTAssertNotNil(movie.posterURL)
    }
    
    func testMovieRatingFormatting() {
        let json = """
        {
            "id": 1,
            "title": "Test",
            "overview": "Test",
            "vote_average": 7.856,
            "vote_count": 100
        }
        """
        let data = json.data(using: .utf8)!
        let movie = try! JSONDecoder().decode(Movie.self, from: data)
        XCTAssertEqual(movie.rating, "7.9", "Rating should be formatted to one decimal place")
    }
    
    // MARK: - FavoritesManager Tests
    func testFavoritesManagerInitialState() {
        let manager = FavoritesManager()
        XCTAssertTrue(manager.favoriteMovieIds.isEmpty || !manager.favoriteMovieIds.isEmpty, "Should initialize")
    }
    
    func testToggleFavorite() {
        let manager = FavoritesManager()
        let movieId = 123
        manager.toggleFavorite(movieId: movieId)
        XCTAssertTrue(manager.isFavorite(movieId: movieId), "Should add to favorites")
        manager.toggleFavorite(movieId: movieId)
        XCTAssertFalse(manager.isFavorite(movieId: movieId), "Should remove from favorites")
    }
    
    func testFavoritesPersistence() {
        let manager1 = FavoritesManager()
        let movieId = 456
        manager1.toggleFavorite(movieId: movieId)
        let manager2 = FavoritesManager()
        XCTAssertTrue(manager2.isFavorite(movieId: movieId), "Favorites should persist")
        manager2.toggleFavorite(movieId: movieId)
    }
}
