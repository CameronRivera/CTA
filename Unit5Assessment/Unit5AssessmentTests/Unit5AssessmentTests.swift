//
//  Unit5AssessmentTests.swift
//  Unit5AssessmentTests
//
//  Created by Cameron Rivera on 3/14/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import XCTest
import Firebase
@testable import Unit5Assessment

class Unit5AssessmentTests: XCTestCase {
    
    override func setUp(){
        super.setUp()
        FirebaseApp.configure()
    }

    func testNetworkHelper(){
        // Arrange
        
        let endpoint = "https://www.rijksmuseum.nl/api/en/collection?key=\(APIKey.rijksAPIKey)&q=\(RijksMuseumAPI.percentEncoding("rembrandt"))"
        let exp = expectation(description: "Return Data")
        guard let url = URL(string: endpoint) else {
            XCTFail("BadURL: \(endpoint)")
            return
        }
        let request = URLRequest(url: url)
        
        // Act
        
        NetworkHelper.shared.performDataTask(request) { result in
            switch result{
            case .failure(let netError):
                XCTFail("Failure: \(netError.localizedDescription)")
            case .success(let data):
                exp.fulfill()
                // Assert
                XCTAssertNotNil(data)
            }
        }
        
        wait(for: [exp], timeout: 3.0)
    }
    
    func testGetArtPieces(){
        // Arrange
        
        let exp = expectation(description:"Self-portriat returned")
        let expectedTitle = "Self-portrait"
        
        // Act
        RijksMuseumAPI.getPieces("rembrandt") { result in
            switch result{
            case .failure(let netError):
                XCTFail(netError.localizedDescription)
            case .success(let pieces):
                // Assert
                exp.fulfill()
                if let firstPiece = pieces.first{
                    XCTAssertEqual(expectedTitle, firstPiece.title)
                }
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func testGetDetailedArtPieces(){
        // Arrange
        
        let exp = expectation(description: "Maker named: Mary Georgiana Filmer (Lady)")
        let expectedMaker = "Mary Georgiana Filmer (Lady)"
        
        // Act
        RijksMuseumAPI.getDetailedPieces("RP-F-2018-79-4") { result in
            switch result{
            case .failure(let netError):
                XCTFail(netError.localizedDescription)
            case .success(let detailedPiece):
                // Assert
                exp.fulfill()
                if let firstMaker = detailedPiece.principalMakers.first{
                    XCTAssertEqual(expectedMaker, firstMaker.name)
                } else {
                    XCTFail("Could not retrieve a maker")
                }
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func testGetEvents(){
        // Arrange
        let exp = expectation(description: "Return Chicago white sox game")
        let endpoint = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(APIKey.ticketMasterKey)&City=\(TicketMasterAPI.percentEncoding("chicago"))"
        
        // Act
        TicketMasterAPI.getEvents(endpoint) { result in
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let events):
                //Assert
                exp.fulfill()
                if let firstEvent = events.first {
                    XCTAssertEqual(firstEvent.name, "Chicago White Sox vs. New York Yankees")
                }
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func testGetDetailedEvent(){
        // Arrange
        let exp = expectation(description: "Return event named Eagles")
        let expectedEventTitle = "Eagles"
        
        // Act
        TicketMasterAPI.getDetailedEventInfo("G5vzZ4g6yyBHk") { result in
            switch result{
            case .failure(let netError):
                XCTFail(netError.localizedDescription)
            case .success(let detailedEvent):
                // Assert
                exp.fulfill()
                XCTAssertEqual(expectedEventTitle, detailedEvent.name)
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func testEndUserModel(){
        // Arrange
        let endUserEmail = "Cameron@domain.com"

        // Act
        let user = EndUser(userId: "", timeCreated: Timestamp(date: Date()), email: "Cameron@domain.com", selectedExperience: "")

        // Assert
        XCTAssertEqual(user.email, endUserEmail)

    }
    
    func testAuthentication() {
        // Arrange
        let endUserEmail = "cameron@domain.com"
        
        // Act
        guard let user = Auth.auth().currentUser else {
            XCTFail("Could not get user.")
            return
        }
        
        // Assert
        XCTAssertEqual(endUserEmail, user.email ?? "")
    }
}
