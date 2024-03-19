//
//  CharactersFlowCoordinator.swift
//  MVVMC+Combine
//
//  Created by Davit on 05.03.24.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersViewController(onSelect: @escaping ((Int) -> Void)) -> CharactersViewController
    func makeCharactersDetailsViewController(for characterID: Int) -> CharacterDetailsViewController
}

class CharactersFlowCoordinator {
    weak var navigationController: UINavigationController?
    let factory: CharactersFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, factory: CharactersFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let vc = factory.makeCharactersViewController(onSelect: showDetails)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDetails(for characterID: Int) {
        let vc = factory.makeCharactersDetailsViewController(for: characterID)
        navigationController?.pushViewController(vc, animated: true)
    }
}
