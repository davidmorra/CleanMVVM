//
//  CharactersFlowCoordinator.swift
//  MVVMC+Combine
//
//  Created by Davit on 05.03.24.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersViewController() -> CharactersViewController
    func makeCharactersDetailsViewController(for characterID: Int) -> CharacterDetailsViewController
}

class CharactersFlowCoordinator: CharactersFlowCoordinatorDependencies {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = makeCharactersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDetails(for characterID: Int) {
        let vc = makeCharactersDetailsViewController(for: characterID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeCharactersViewController() -> CharactersViewController {
        let vm = CharactersViewModel(onSelect: showDetails)
        return CharactersViewController(viewmodel: vm)
    }
    
    func makeCharactersDetailsViewController(for characterID: Int) -> CharacterDetailsViewController {
        let vm = CharacteresDetailsViewModel(characterID: characterID)
        let vc = CharacterDetailsViewController(viewmodel: vm)
        return vc
    }
}
