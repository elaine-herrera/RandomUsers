//
//  UsersModel.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 14/7/22.
//

import Foundation

protocol UserViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class UsersViewModel {
    private weak var delegate: UserViewModelDelegate?
    
    private var users: [User] = []
    private var total = 0
    private var currentPage = 1
    private var pagination = 50
    private var batch = 1000
    private var isFetchInProgress = false
    
    var provider: UserProvider
    
    init(provider: UserProvider, delegate: UserViewModelDelegate) {
        self.provider = provider
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return users.count
    }
    
    var totalCount: Int {
        return total
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    func fetchUsers() {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        provider.listOfUsers(userCount: pagination, page: currentPage) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isFetchInProgress = false
                    self?.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    let page = self?.currentPage ?? 0
                    self?.currentPage += 1
                    self?.isFetchInProgress = false
                    
                    self?.users.append(contentsOf: response)
                    
                    if page > 1  {
                        let indexPathsToReload = self?.calculateIndexPathsToReload(from: response)
                        self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                    }
                    else {
                        self?.total = self?.batch ?? 0
                        self?.delegate?.onFetchCompleted(with: .none)
                    }
                    guard let max = self?.total, let loaded = self?.users.count else { return }
                    print("Loaded: \(loaded) -- Max Value \(max)")
                    if max <= loaded {
                        self?.total += self?.batch ?? 0
                        self?.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newUsers: [User]) -> [IndexPath] {
        let startIndex = users.count - newUsers.count
        let endIndex = startIndex + newUsers.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
