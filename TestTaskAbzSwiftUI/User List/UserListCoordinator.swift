//
//  UserListCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

// MARK: - UserListCoordinatorProtocol
protocol UserListCoordinatorProtocol {
    var selectedTab: Int { get }
    func startSignUpFlow(existingEmails: Set<String>)
}

final class UserListCoordinator: UserListCoordinatorProtocol {
    var mainCoordinator: MainCoordinatorProtocol
    
    var selectedTab: Int {
        mainCoordinator.selectedTab
    }
    
    // MARK: - Initialization
    init(mainCoordinator: MainCoordinatorProtocol) {
        self.mainCoordinator = mainCoordinator
    }
    
    // Starts the Sign Up flow by creating the necessary ViewModel and View.
    func startSignUpFlow(existingEmails: Set<String>) { 
        mainCoordinator.startSignUpFlow(existingEmails: existingEmails)
    }
   
    // Initializes and starts the User List flow.
    func start() {
        let viewModel = UserListViewModel(networkService: NetworkManager(),
                                          coordinator: self,
                                          networkMonitor: NetworkMonitor())
        let view = UserListView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        
        mainCoordinator.setRootController(host)
    }
    
}
