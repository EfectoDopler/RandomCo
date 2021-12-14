//
//  RandomCoTests.swift
//  RandomCoTests
//
//  Created by José Escudero on 12/11/21.
//

import XCTest
@testable import RandomCo

class RandomCoTests: XCTestCase {

    /*
     JSON MOCK HAVE 5 USERS BUT 1 IS REPEAT
     TEST IS OK IF MODEL HAS 4 USERS AFTER SET THE USER LIST
     */
    func testHomeModelRemoveDuplicateUsers() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        XCTAssertTrue(model.getUserCount() == 4)
    }
    
    /*
     JSON MOCK HAVE 2 USER MALES AND 2 USER FEMALES SEPARATED
     TEST IS OK IF POS 0 AND 1 ARE FEMALES AND 2 AND 3 MALES AFTER FILTER BY FEMALE
     */
    func testHomeModelFilterByFemale() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.addFilter(type: .female)
        XCTAssertTrue(model.getUserInfoFor(index: 0).gender == "female")
        XCTAssertTrue(model.getUserInfoFor(index: 1).gender == "female")
        XCTAssertTrue(model.getUserInfoFor(index: 2).gender == "male")
        XCTAssertTrue(model.getUserInfoFor(index: 3).gender == "male")
    }
    
    /*
     JSON MOCK HAVE 2 USER MALES AND 2 USER FEMALES SEPARATED
     TEST IS OK IF POS 0 AND 1 ARE FEMALES AND 2 AND 3 MALES AFTER FILTER BY MALE
     */
    func testHomeModelFilterByMale() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.addFilter(type: .male)
        XCTAssertTrue(model.getUserInfoFor(index: 0).gender == "male")
        XCTAssertTrue(model.getUserInfoFor(index: 1).gender == "male")
        XCTAssertTrue(model.getUserInfoFor(index: 2).gender == "female")
        XCTAssertTrue(model.getUserInfoFor(index: 3).gender == "female")
    }
    

    // TEST IS OK IF NAMES USERS ARE SORTED BY NAME ASCENDING
    func testHomeModelFilterByName() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.addFilter(type: .asc)
        XCTAssertTrue(model.getUserInfoFor(index: 0).name == "Aleksi Maunu")
        XCTAssertTrue(model.getUserInfoFor(index: 1).name == "Andreas Lande")
        XCTAssertTrue(model.getUserInfoFor(index: 2).name == "Carole Rousseau")
        XCTAssertTrue(model.getUserInfoFor(index: 3).name == "Maëva Andre")
    }
    
    // TEST IS OK IF NAMES USERS ARE SORTED BY FEMALE FIRST AND CONTAINS "Ma"
    func testHomeModelFilterByFemaleAndSearch() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.obtainSearchName(name: "Ma")  
        model.addFilter(type: .female)
        XCTAssertTrue(model.getUserCount() == 2)
        XCTAssertTrue(model.getUserInfoFor(index: 0).name == "Maëva Andre")
        XCTAssertTrue(model.getUserInfoFor(index: 1).name == "Aleksi Maunu")
    }
    
    // TEST IS OK IF NAMES USERS ARE SORTED BY MALE FIRST AND CONTAINS "Ma"
    func testHomeModelFilterByMaleAndSearch() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.obtainSearchName(name: "Ma")
        model.addFilter(type: .male)
        XCTAssertTrue(model.getUserCount() == 2)
        XCTAssertTrue(model.getUserInfoFor(index: 0).name == "Aleksi Maunu")
        XCTAssertTrue(model.getUserInfoFor(index: 1).name == "Maëva Andre")
    }
    
    // TEST IS OK IF NAMES USERS ARE SORTED BY NAME ASCENDING AND CONTAINS "Ma"
    func testHomeModelFilterByNameAndSearch() throws {
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.obtainSearchName(name: "Ma")
        model.addFilter(type: .asc)
        XCTAssertTrue(model.getUserCount() == 2)
        XCTAssertTrue(model.getUserInfoFor(index: 0).name == "Aleksi Maunu")
        XCTAssertTrue(model.getUserInfoFor(index: 1).name == "Maëva Andre")
    }
    
    // TEST IS OK IF Aleksi is saved as favourite
    func testFavouriteManagerSaveUser() throws {
        let favourites = RCFavouriteUsers.shared
        let users = RCMockManager().loadUsers()
        favourites.clean()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.obtainSearchName(name: "Ma")
        model.addFilter(type: .asc)
        XCTAssertTrue(model.getUserCount() == 2)
        XCTAssertTrue(model.getUserInfoFor(index: 0).name == "Aleksi Maunu")
        XCTAssertTrue(model.getUserInfoFor(index: 1).name == "Maëva Andre")
        model.favouriteItem(index: 0)
        XCTAssertTrue(favourites.getFavouriteUsers()[0].name?.first == "Aleksi")
    }
    
    // TEST IS OK IF Maëva is saved as favourite and later is removed
    func testFavouriteManagerSaveAndRemoveUser() throws {
        let favourites = RCFavouriteUsers.shared
        let users = RCMockManager().loadUsers()
        favourites.clean()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.obtainSearchName(name: "Ma")
        model.addFilter(type: .female)
        XCTAssertTrue(model.getUserCount() == 2)
        XCTAssertTrue(model.getUserInfoFor(index: 0).name == "Maëva Andre")
        XCTAssertTrue(model.getUserInfoFor(index: 1).name == "Aleksi Maunu")
        model.favouriteItem(index: 0)
        XCTAssertTrue(favourites.getFavouriteUsers()[0].name?.first == "Maëva")
        model.favouriteItem(index: 0)
        XCTAssertTrue(favourites.getFavouriteUsers().count == 0)
    }

    /*
     COORD1: PLAZA DE SOL COORDINATES
     COORD2: GRAN VIA COORDINATES
     TEST IS MUST BE OK BECAUSE DISTNACE IS LESS THAN 1000 METERS
     */
    func testDistanceBetweenCoordinatesLessThan1Km() throws {
        let coord1 = Coordinate(latitude: "40.4167881", longitude: "-3.7042029")
        let coord2 = Coordinate(latitude: "40.4175026", longitude: "-3.703367")
        let distance = Coordinate.calculateDistance(coord1: coord1, coord2: coord2)
        XCTAssertTrue(distance < 1000)
    }
    
    /*
     COORD1: PLAZA DE SOL COORDINATES
     COORD2: LEGAZPI CULTURAL CENTER COORDINATES
     TEST MUST BE OK BECAUSE DISTANCE IS MORE THAN 1000 METERS
     */
    func testDistanceBetweenCoordinatesMoreThan1Km() throws {
        let coord1 = Coordinate(latitude: "40.4167881", longitude: "-3.7042029")
        let coord2 = Coordinate(latitude: "40.3912935", longitude: "-3.6999277")
        let distance = Coordinate.calculateDistance(coord1: coord1, coord2: coord2)
        XCTAssertTrue(distance > 1000)
    }
    
    /*
     JSON HAS USER Andreas Lande WITH latitude: "40.3912935" longitude: "-3.6999277"
     TEST MUST BE OK BECAUSE FIRST DISTANCE IS  PLAZA SOL AND SECOND IS GRAN VIA
     */
    func testFilterByDistance() throws {
        let coord = Coordinate(latitude: "40.4167881", longitude: "-3.7042029")
        let users = RCMockManager().loadUsers()
        XCTAssertTrue(users.count != 0)
        let model = RCHomeViewModel(favouriteMode: false)
        model.setUsers(users: users)
        model.addFilter(type: .distance, coord: coord)
        XCTAssertTrue(model.getUserCount() == 1)
        let userInfo = model.getUserFor(index: 0)
        XCTAssertTrue(userInfo.name == "Andreas Lande")
    }
}
