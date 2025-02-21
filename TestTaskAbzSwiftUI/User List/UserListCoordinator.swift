//
//  UserListCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

protocol UserListCoordinatorProtocol {
    func startSignUpFlow()
}

final class UserListCoordinator: UserListCoordinatorProtocol {
    var mainCoordinator: MainCoordinatorProtocol
    
    init(mainCoordinator: MainCoordinatorProtocol) {
        self.mainCoordinator = mainCoordinator
    }
    
    func startSignUpFlow() {
        mainCoordinator.startSignUpFlow()
    }
    
    func start() {
        let viewModel = UserListViewModel(networkService: NetworkManager(),
                                          coordinator: self,
                                          networkMonitor: NetworkMonitor())
        let view = UserListView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        
        mainCoordinator.setRootController(host)
    }
    
}
