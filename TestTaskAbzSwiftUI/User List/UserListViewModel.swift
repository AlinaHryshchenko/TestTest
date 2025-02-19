//
//  UserListViewModel.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation

protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var selectedTab: Int { get set }
    func loadUsers()
    func navigateToSignUp()
    func loadNextPageIfNeeded(currentItem user: User?)
}

final class UserListViewModel: UserListViewModelProtocol {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var canLoadMore: Bool = true
    
    var selectedTab: Int = 0
    private var currentPage = 1
    private let pageSize = 6
    private var totalUsers: Int = 0

    private let networkService: NetworkProtocol
    private let coordinator: UserListCoordinatorProtocol
    
    init(networkService: NetworkProtocol, coordinator: UserListCoordinatorProtocol) {
        self.networkService = networkService
        self.coordinator = coordinator
    }
    
    func loadUsers() {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        networkService.fetchUsers(page: currentPage, count: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let newUsers):
                    self?.users.append(contentsOf: newUsers)
                    self?.canLoadMore = !newUsers.isEmpty
                    self?.currentPage += 1
                    
                case .failure(let error):
                    print("Error loading users: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func loadNextPageIfNeeded(currentItem user: User?) {
        guard let user = user else {
            loadUsers()
            return
        }
        
        if let lastUser = users.last, user.id == lastUser.id {
            loadUsers()
        }
    }
    
    func navigateToSignUp() {
        coordinator.startSignUpFlow()
    }
    
    
}

