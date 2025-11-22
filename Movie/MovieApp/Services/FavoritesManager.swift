//
//  FavoritesManager.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteMovieIds: Set<Int> = []
    
    private let favoritesKey = "favoriteMovies"
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(movieId: Int) {
        if favoriteMovieIds.contains(movieId) {
            favoriteMovieIds.remove(movieId)
        } else {
            favoriteMovieIds.insert(movieId)
        }
        saveFavorites()
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favoriteMovieIds.contains(movieId)
    }
    
    private func saveFavorites() {
        let array = Array(favoriteMovieIds)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let array = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favoriteMovieIds = Set(array)
        }
    }
}
