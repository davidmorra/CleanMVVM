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
    let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer, navigationController: UINavigationController) {
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
    }
    
    func start() {
        let container = appDIContainer.makeCharacteresDIContainer()
        let characterFlowCoordinator = CharactersFlowCoordinator(navigationController: navigationController, factory: container)
        characterFlowCoordinator.start()
    }
}
