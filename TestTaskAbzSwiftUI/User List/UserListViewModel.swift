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
    var loadingStartTime: Date? { get }
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
    @Published var loadingStartTime: Date?

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
        self.selectedTab = coordinator.selectedTab
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
        
        networkService.fetchUsers(page: currentPage, count: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingStartTime = Date()
                
                switch result {
                case .success(let (newUsers, totalPages, nextLink)):
                    self?.users.append(contentsOf: newUsers.sorted {
                        $0.registration_timestamp > $1.registration_timestamp
                    })
                    
                    newUsers.forEach { user in
                        self?.emails.insert(user.email)
                    }
                    self?.nextPageLink = nextLink
                    self?.canLoadMore = self?.users.count ?? 0 < totalPages * (self?.pageSize ?? 1)
                    self?.currentPage += 1
                    
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
            loadUsers(nextPageLink: nextLink)
        }
    }
    
    // MARK: - Navigation
    func navigateToSignUp() {
        coordinator.startSignUpFlow(existingEmails: emails)
    }
}



