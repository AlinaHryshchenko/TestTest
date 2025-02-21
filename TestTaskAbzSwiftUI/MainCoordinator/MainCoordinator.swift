//
//  MainCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

protocol MainCoordinatorProtocol {
    var selectedTab: Int { get set }
    func setRootController(_ controller: UIViewController)
    func startHomeFlow()
    func startSignUpFlow()
}

final class MainCoordinator: MainCoordinatorProtocol {
    @Published var selectedTab: Int = 0
    var rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let networkService = NetworkManager()
        let userListCoordinator = UserListCoordinator(mainCoordinator: self)
        let userListViewModel = UserListViewModel(networkService: networkService,
                                                  coordinator: userListCoordinator,
                                                  networkMonitor: NetworkMonitor())                
        let view = UserListView(viewModel: userListViewModel)
        let splashViewController = UIHostingController(rootView: view)
        rootNavigationController.viewControllers = [splashViewController]
    }
    
    func startHomeFlow() {
        selectedTab = 0
        let userListCoordinator = UserListCoordinator(mainCoordinator: self)
        userListCoordinator.start()
    }
    
    func startSignUpFlow() {
        selectedTab = 1 
        let signUpCoordinator = SignUpCoordinator(mainCoordinator: self, imageManager: ImageServices(), networkManager: NetworkManager())
        signUpCoordinator.start()
    }
    
    func setRootController(_ controller: UIViewController) {
        rootNavigationController.viewControllers = [controller]
    }
}
