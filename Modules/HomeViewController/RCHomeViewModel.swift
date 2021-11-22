//
//  RCHomeViewModel.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation

class RCHomeViewModel {
    
    // MARK: - VARIABLE DECLARATION

    private var networkManager: RCNetworkManager
    private var favouriteMode: Bool
    
    var favouriteUsers: RCFavouriteUsers
    
    private var filterType: RCHomeStatusFilter
    private var searchName: String
    private var users: [User]
    private var myCoord: Coordinate!
    
    @Published private(set) var showUsers: [User]
    
    // MARK: - CONSTRUCTOR
    
    init(favouriteMode: Bool) {
        self.favouriteMode = favouriteMode
        users = [User]()
        showUsers = [User]()
        networkManager = RCNetworkManager()
        searchName = ""
        filterType = .none
        favouriteUsers = RCFavouriteUsers.shared
    }
    
    // MARK: - SET USER LIST
    
    func setUsers(users: [User]) {
        saveObtainedUsers(users: users)
    }
    
    // MARK: - LOAD USER INFORMATION
    
    func obtainUsersInformation() {
        if favouriteMode {
            favouriteUsers = RCFavouriteUsers.shared
            saveObtainedUsers(users: favouriteUsers.getFavouriteUsers())
        } else {
            networkManager.homeDataRequest { [weak self] result in
                switch result {
                    case .success(let users):
                        self?.saveObtainedUsers(users: users)
                    case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func saveObtainedUsers(users: [User]) {
        if favouriteMode {
            self.users = users
            self.showUsers = self.users
        } else {
            self.users.append(contentsOf: users)
        }
        self.users = self.users.removingDuplicates()
        searchAndFilterUsers()
    }
    
    // MARK: - GET USER
    
    func getUserCount() -> Int {
        return self.showUsers.count
    }
    
    func getUserFor(index: Int) -> RCBasicTableViewCellModel {
        var user: User!
        
        if index < showUsers.count {
            user = showUsers[index]
            
            var cellName = ""
            if let name = user?.name, let first = name.first {
                cellName = first
                if let last = name.last {
                    cellName = cellName + " " + last
                }
            }
       
            return RCBasicTableViewCellModel(
                name: cellName,
                email: user.email ?? "",
                phone: user.phone ?? "",
                url: user.picture?.large ?? "",
                favourite: favouriteUsers.userIsFavourite(user: user),
                favouriteMode: favouriteMode,
                id: index)
        }  else {
            return RCBasicTableViewCellModel(
                name: "",
                email: "",
                phone: "",
                url: "",
                favourite: false,
                favouriteMode: favouriteMode,
                id: 0)
        }
       
    }
    
    func getUserInfoFor(index: Int) -> UserInfo {
        return UserInfoMapper.createUserInfo(from: showUsers[index])
    }
    
    // MARK: - REMOVE USER FORM LIST
    
    func removeItem(index: Int) {
        if index < showUsers.count {
            let user = showUsers[index]
            if favouriteUsers.userIsFavourite(user: user) {
                favouriteUsers.removeFavourite(user: user)
            }
            
            var ind = 0
            for usr in users {
                if usr == user {
                    break
                }
                ind = ind + 1
            }
            showUsers.remove(at: index)
            users.remove(at: ind)
        }
    }
    
    // MARK: - MODIFY FAVOURITE USER LIST
    
    func favouriteItem(index: Int) {
        if index < showUsers.count {
            let user = showUsers[index]
            if favouriteUsers.userIsFavourite(user: user) {
                self.favouriteUsers.removeFavourite(user: user)
                if favouriteMode {
                    obtainUsersInformation()
                }
            } else {
                self.favouriteUsers.addFavourite(user: user)
            }
        }
    }
    
    func getIsFavouriteMode() -> Bool {
        return favouriteMode
    }
    
    // MARK: - FILTER USERS
    
    func addFilter(type: RCHomeStatusFilter, coord: Coordinate? = nil) {
        myCoord = coord
        filterType = type
        searchAndFilterUsers()
    }
    
    private func filterUsers() {
        if users.count > 0 {
            switch filterType {
            case .none:
                self.showUsers = self.users
            case .male:
                filterByGender(gender: "male")
            case .female:
                filterByGender(gender: "female")
            case .asc:
                filterByOrder()
            case .distance:
                filterByDistance()
            }
        }
    }
    
    private func filterByGender(gender: String) {
        var auxGender = self.users.filter({$0.gender == gender})
        auxGender = auxGender.sorted(by: {$0.name?.first ?? "" < $1.name?.first ?? ""})
        var auxNotGender = self.users.filter({$0.gender != gender})
        auxNotGender = auxNotGender.sorted(by: {$0.name?.first ?? "" < $1.name?.first ?? ""})
        auxGender.append(contentsOf: auxNotGender)
        self.showUsers = auxGender
    }
    
    private func filterByOrder() {
        self.showUsers = self.users.sorted(by: {$0.name?.first ?? "" < $1.name?.first ?? ""})
    }
    
    func filterByDistance() {
        if let coord = myCoord {
            showUsers = users.filter({ Coordinate.calculateDistance(coord1: coord, coord2: ($0.location?.coordinates)!) < 1000})
        }
    }
    
    // MARK: - SEARCH NAME
    
    func obtainSearchName(name: String?) {
        if let name = name, name != "" {
            searchName = name
        } else {
            searchName = ""
        }
        searchAndFilterUsers()
    }
    
    private func searchByName() {
        if showUsers.count > 0 {
            if searchName != "" {
                showUsers = showUsers.filter({
                    ($0.email?.contains(searchName))!
                        || ($0.name?.first?.contains(searchName))!
                        || ($0.name?.last?.contains(searchName))!
                })
            }
        } else {
            showUsers = []
        }
    }
    
    // MARK: - SEARCH AND FILTER
    
    private func searchAndFilterUsers() {
        filterUsers()
        searchByName()
    }
}
