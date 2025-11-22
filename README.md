# MovieApp - TMDb iOS Application

A simple iOS application that integrates with The Movie Database (TMDb) API to display popular movies, detailed information, trailers, search functionality, and favorites management.

## Features

- **Popular Movies List**: Browse trending movies with poster, title, rating, and release date
- **Movie Details**: View comprehensive movie information including:
  - Plot overview
  - Genre(s)
  - Cast members
  - Duration
  - Rating
  - Trailer playback
- **Search**: Find movies by title with real-time search
- **Favorites**: Mark/unmark favorite movies with persistent storage
- **Trailer Playback**: Watch movie trailers via YouTube player

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- TMDb API Key

### Getting Your TMDb API Key

1. Visit [The Movie Database](https://www.themoviedb.org/)
2. Create a free account or sign in
3. Go to Settings → API
4. Request an API key (select "Developer" option)
5. Copy your API key

### Installation Steps

1. Clone or download this repository
2. Open `MovieApp.xcodeproj` in Xcode
3. Open `Config.swift` file
4. Replace `YOUR_TMDB_API_KEY_HERE` with your actual TMDb API key:
   ```swift
   static let apiKey = “your_actual_api_key_here"
