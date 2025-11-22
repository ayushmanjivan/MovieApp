//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel = MovieDetailViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showingTrailer = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if viewModel.isLoading {
                    ProgressView("Loading details...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else if let movie = viewModel.movieDetail {
                    // Backdrop Image
                    if let backdropURL = movie.backdropPath.flatMap({ URL(string: "\(Config.imageBaseURL)\($0)") }) {
                        AsyncImage(url: backdropURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(height: 250)
                        .clipped()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and Favorite Button
                        HStack(alignment: .top, spacing: 16) {
                            Text(movie.title)
                                .font(.system(size: 28, weight: .bold))
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                favoritesManager.toggleFavorite(movieId: movieId)
                            }) {
                                Image(systemName: favoritesManager.isFavorite(movieId: movieId) ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Rating, Duration, Release Date
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(movie.rating)
                            }
                            
                            if let runtime = movie.runtime {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                    Text(movie.durationString)
                                }
                            }
                            
                            if let releaseDate = movie.releaseDate {
                                Text(releaseDate)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        
                        // Genres
                        if !movie.genres.isEmpty {
                            Text(movie.genreString)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                        }
                        
                        // Trailer Button
                        if let trailer = viewModel.trailerVideo {
                            Button(action: {
                                showingTrailer = true
                            }) {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                    Text("Watch Trailer")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .sheet(isPresented: $showingTrailer) {
                                TrailerPlayerView(video: trailer)
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Overview
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overview")
                                .font(.headline)
                            Text(movie.overview)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 16)
                        
                        // Cast
                        if let cast = movie.credits?.cast.prefix(10), !cast.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cast")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(cast)) { member in
                                            CastMemberView(cast: member)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.leading, 16)
                        }
                    }
                    .padding(.vertical, 16)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetails(movieId: movieId)
        }
    }
}
