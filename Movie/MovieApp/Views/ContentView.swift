//
//  ContentView.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            Task {
                                await viewModel.loadPopularMovies()
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movieId: movie.id)
                                    .environmentObject(favoritesManager)) {
                                    MovieRowView(movie: movie, isFavorite: favoritesManager.isFavorite(movieId: movie.id))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreMoviesIfNeeded(currentMovie: movie)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Popular Movies")
            .searchable(text: $viewModel.searchQuery, isPresented: $isSearching, prompt: "Search movies")
            .onChange(of: viewModel.searchQuery) { oldValue, newValue in
                Task {
                    if newValue.isEmpty {
                        viewModel.resetSearch()
                    } else if newValue.count >= 2 {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        if viewModel.searchQuery == newValue {
                            await viewModel.searchMovies()
                        }
                    }
                }
            }
            .task {
                await viewModel.loadPopularMovies()
            }
            .environmentObject(favoritesManager)
        }
    }
}

#Preview {
    ContentView()
}
