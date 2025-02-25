//
//  MainCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

// MARK: - MainCoordinatorProtocol
protocol MainCoordinatorProtocol {
    var selectedTab: Int { get set }
    func setRootController(_ controller: UIViewController)
    func startUserListFlow()
    func startSignUpFlow(existingEmails: Set<String>)
}

// MARK: - MainCoordinator
final class MainCoordinator: MainCoordinatorProtocol {
    @Published var selectedTab: Int = 0
    var rootNavigationController: UINavigationController
   
    // MARK: - Initialization
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    // MARK: - Start
    // Initial setup of the app. Configures the root view controller with the User List
    func start() {
        let networkService = NetworkManager()
        let userListCoordinator = UserListCoordinator(mainCoordinator: self)
        let userListViewModel = UserListViewModel(
            networkService: networkService,
            coordinator: userListCoordinator,
            networkMonitor: NetworkMonitor())
        let view = UserListView(viewModel: userListViewModel)
        let splashViewController = UIHostingController(rootView: view)
        rootNavigationController.viewControllers = [splashViewController]
    }
    
    // Starts the User List flow and sets it as the selected tab.
    func startUserListFlow() {
        selectedTab = 0
        let userListCoordinator = UserListCoordinator(mainCoordinator: self)
        userListCoordinator.start()
    }
    
    // Starts the Sign Up flow and sets it as the selected tab.
    func startSignUpFlow(existingEmails: Set<String>) {
        selectedTab = 1
        let signUpCoordinator = SignUpCoordinator(
            mainCoordinator: self,
            imageManager: ImageServices(),
            networkManager: NetworkManager())
        signUpCoordinator.start(existingEmails: existingEmails)
    }
    
    // Sets the root view controller for the navigation stack.
    func setRootController(_ controller: UIViewController) {
        rootNavigationController.viewControllers = [controller]
    }
}
