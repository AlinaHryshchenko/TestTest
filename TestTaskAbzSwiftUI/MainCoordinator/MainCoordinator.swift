//
//  MainCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

protocol MainCoordinatorProtocol {
    func setRootController(_ controller: UIViewController)
    func startHomeFlow()
    func startSignUpFlow()
}






final class MainCoordinator: MainCoordinatorProtocol {
    var rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
      
    }
    
    func start() {
        let networkService = NetworkManager()
        let userListCoordinator = UserListCoordinator(mainCoordinator: self)
        let userListViewModel = UserListViewModel(networkService: networkService, coordinator: userListCoordinator)
                
        let view = UserListView(viewModel: userListViewModel)
        
        let splashViewController = UIHostingController(rootView: view)
        rootNavigationController.viewControllers = [splashViewController]
    }
    
    func startHomeFlow() {
        let userListCoordinator = UserListCoordinator(mainCoordinator: self)
        userListCoordinator.start()
    }
    
    func startSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(mainCoordinator: self, imageManager: ImageServices(), networkManager: NetworkManager())
        signUpCoordinator.start()
    }
    
    func setRootController(_ controller: UIViewController) {
        rootNavigationController.viewControllers = [controller]
    }
}
