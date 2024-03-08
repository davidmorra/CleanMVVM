//
//  Coordinator.swift
//  MVVMC+Combine
//
//  Created by Davit on 13.02.24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let characterFlowCoordinator = CharactersFlowCoordinator(navigationController: navigationController)
        characterFlowCoordinator.start()
    }
}
