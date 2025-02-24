//
//  UserListViewModel.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import Combine

// MARK: - UserListViewModelProtocol
protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var selectedTab: Int { get set }
    var isLoading: Bool  { get set }
    var isConnected: Bool { get set }
    var hasLoadingFailed: Bool { get }
    func loadUsers(nextPageLink: String?)
    func navigateToSignUp()
    func loadNextPageIfNeeded(currentItem user: User?)
    func checkInternetConnection()
}

final class UserListViewModel: UserListViewModelProtocol {
    @Published private(set) var users: [User] = []
    @Published var isLoading: Bool = false
    @Published private(set) var canLoadMore: Bool = true
    @Published var selectedTab: Int
    @Published var isConnected: Bool = true
    @Published var hasLoadingFailed: Bool = false
    @Published var emails: Set<String> = []
    
    private var currentPage = 1
    private let pageSize = 6
    private var totalUsers: Int = 0
    private var totalPages: Int = 1
    private var nextPageLink: String?
    private var prevPageLink: String?
    private var cancellables = Set<AnyCancellable>()
    private let networkMonitor: NetworkMonitorProtocol
    private let networkService: NetworkProtocol
    private let coordinator: UserListCoordinatorProtocol
    
    // MARK: - Initialization
    init(networkService: NetworkProtocol, coordinator: UserListCoordinatorProtocol, networkMonitor: NetworkMonitorProtocol) {
        self.networkService = networkService
        self.coordinator = coordinator
        self.selectedTab = (coordinator as? MainCoordinator)?.selectedTab ?? 0
        self.networkMonitor = networkMonitor
        
        // Network connection changes
        networkMonitor.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isConnected = isConnected
                if isConnected {
                    self?.loadUsers(nextPageLink: nil)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Internet Connection Check
    func checkInternetConnection() {
        isConnected = networkMonitor.isConnected
        if isConnected {
            loadUsers(nextPageLink: nil)
        }
    }
    
    // MARK: - Load Users
    func loadUsers(nextPageLink: String? = nil) {
        guard !isLoading, canLoadMore else { return }
       
        if !isConnected {
            print("No internet connection")
            return
        }
        
        isLoading = true
        hasLoadingFailed = false
        
        let pageLink = nextPageLink ?? "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(currentPage)&count=\(pageSize)"
        
        print("Loading users from: \(pageLink), Current page: \(currentPage)")
        
        networkService.fetchUsers(page: currentPage, count: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let (newUsers, totalPages, nextLink)):
                    print("Successfully loaded \(newUsers.count) users. Total pages: \(totalPages)")
                    
                    newUsers.forEach { user in
                        print("User: \(user.name), Registration Date: \(user.registration_timestamp)")
                    }
                    
                    self?.users.append(contentsOf: newUsers.sorted {
                        $0.registration_timestamp > $1.registration_timestamp
                    })
                    
                    newUsers.forEach { user in
                        self?.emails.insert(user.email)
                    }
                    
                    print("Sorted users:")
                    self?.users.forEach { user in
                        print("User: \(user.name), Sorted Registration Date: \(user.registration_timestamp)")
                    }
                    
                    self?.nextPageLink = nextLink
                    print("Next page link: \(String(describing: self?.nextPageLink))")
                    
                    self?.canLoadMore = self?.users.count ?? 0 < totalPages * (self?.pageSize ?? 1)
                    self?.currentPage += 1
                    print("Can load more: \(self?.canLoadMore ?? false)")
                    
                case .failure(let error):
                    print("Error loading users: \(error.localizedDescription)")
                    self?.hasLoadingFailed = true
                }
            }
        }
    }
    
    // Loads the next page of users if the current item is the last one in the list.
    func loadNextPageIfNeeded(currentItem user: User?) {
        guard let user = user else {
            print("No current item to check. Loading first page.")
            loadUsers()
            return
        }
        
        if let lastUser = users.last, user.id == lastUser.id, let nextLink = nextPageLink {
            print("Last user reached, loading next page.")
            loadUsers(nextPageLink: nextLink)
        }
    }
    
    // MARK: - Navigation
    func navigateToSignUp() {
        coordinator.startSignUpFlow(existingEmails: emails)

    }
}



