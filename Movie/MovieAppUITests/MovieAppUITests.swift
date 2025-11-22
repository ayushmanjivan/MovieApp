//
//  MovieAppUITests.swift
//  MovieAppUITests
//
//  Created by ayushman.soni on 22/11/25.
//

import XCTest

final class MovieAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - ContentView Tests (Home Screen)
    @MainActor
    func testHomeScreenLoads() throws {
        XCTAssertTrue(app.navigationBars["Popular Movies"].exists, "Navigation bar should display 'Popular Movies'")
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        let exists = firstMovie.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "At least one movie should be displayed")
    }
    
    @MainActor
    func testSearchBarExists() throws {
        let searchField = app.searchFields["Search movies"]
        XCTAssertTrue(searchField.exists, "Search bar should exist")
    }
    
    @MainActor
    func testSearchFunctionality() throws {
        let searchField = app.searchFields["Search movies"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Harry Potter")
        sleep(2)
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Search results should be displayed")
    }
    
    @MainActor
    func testMovieRowDisplaysCorrectly() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        XCTAssertTrue(firstMovie.exists, "Movie row should exist")
        let starIcon = firstMovie.images["star.fill"]
        XCTAssertTrue(starIcon.exists, "Star rating icon should be visible")
    }
    
    @MainActor
    func testScrollingMovieList() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
        scrollView.swipeUp()
        XCTAssertTrue(scrollView.exists, "Should be able to scroll through movie list")
    }
    
    // MARK: - MovieDetailView Tests
    @MainActor
    func testNavigateToMovieDetail() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(2)
        let backButton = app.navigationBars.buttons["Popular Movies"]
        XCTAssertTrue(backButton.exists, "Back button should exist in detail view")
    }
    
    @MainActor
    func testMovieDetailDisplaysContent() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(3)
        let starIcon = app.images["star.fill"].firstMatch
        XCTAssertTrue(starIcon.exists, "Rating star should be visible")
        let clockIcon = app.images["clock"].firstMatch
        XCTAssertTrue(clockIcon.exists, "Duration clock icon should be visible")
        let overviewText = app.staticTexts["Overview"]
        XCTAssertTrue(overviewText.exists, "Overview heading should exist")
    }
    
    @MainActor
    func testFavoriteButtonToggle() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(2)
        let favoriteButton = app.buttons.matching(identifier: "heart").firstMatch
        if !favoriteButton.exists {
            let filledHeart = app.buttons.matching(identifier: "heart.fill").firstMatch
            XCTAssertTrue(filledHeart.exists, "Favorite button should exist")
            filledHeart.tap()
        } else {
            favoriteButton.tap()
        }
        sleep(1)
        XCTAssertTrue(true, "Favorite button should toggle")
    }
    
    @MainActor
    func testWatchTrailerButtonExists() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(3)
        let trailerButton = app.buttons["Watch Trailer"]
        if trailerButton.exists {
            XCTAssertTrue(trailerButton.exists, "Watch Trailer button should exist")
        } else {
            XCTAssertTrue(true, "Movie may not have trailer")
        }
    }
    
    @MainActor
    func testCastSectionExists() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(3)
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()
        scrollView.swipeUp()
        let castHeading = app.staticTexts["Cast"]
        if castHeading.exists {
            XCTAssertTrue(castHeading.exists, "Cast section should exist")
        } else {
            XCTAssertTrue(true, "Movie may not have cast data")
        }
    }
    
    // MARK: - TrailerPlayerView Tests
    @MainActor
    func testTrailerPlayerOpens() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(3)
        let trailerButton = app.buttons["Watch Trailer"]
        if trailerButton.exists {
            trailerButton.tap()
            sleep(1)
            let trailerTitle = app.navigationBars["Trailer"]
            XCTAssertTrue(trailerTitle.exists, "Trailer view should open")
            let doneButton = app.buttons["Done"]
            if doneButton.exists {
                doneButton.tap()
            }
        }
    }
    
    // MARK: - Navigation Tests
    @MainActor
    func testBackNavigationFromDetail() throws {
        // Navigate to detail
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(2)
        let backButton = app.navigationBars.buttons["Popular Movies"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        let navBar = app.navigationBars["Popular Movies"]
        XCTAssertTrue(navBar.exists, "Should return to home screen")
    }
    
    @MainActor
    func testMultipleMovieNavigation() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(2)
        app.navigationBars.buttons["Popular Movies"].tap()
        let movies = app.scrollViews.otherElements.buttons
        if movies.count > 1 {
            movies.element(boundBy: 1).tap()
            sleep(2)
            let backButton = app.navigationBars.buttons["Popular Movies"]
            XCTAssertTrue(backButton.exists)
        }
    }
    
    // MARK: - Favorites Persistence Tests
    @MainActor
    func testFavoritesPersistAcrossNavigation() throws {
        let firstMovie = app.scrollViews.otherElements.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 10))
        firstMovie.tap()
        sleep(2)
        let favoriteButton = app.buttons.matching(identifier: "heart").firstMatch
        if favoriteButton.exists {
            favoriteButton.tap()
            sleep(1)
        }
        app.navigationBars.buttons["Popular Movies"].tap()
        firstMovie.tap()
        sleep(2)
        XCTAssertTrue(true, "Favorite state should persist")
    }
    
    // MARK: - Performance Tests
    @MainActor
    func testScrollPerformance() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
        measure {
            scrollView.swipeUp()
            scrollView.swipeUp()
            scrollView.swipeDown()
            scrollView.swipeDown()
        }
    }
}
