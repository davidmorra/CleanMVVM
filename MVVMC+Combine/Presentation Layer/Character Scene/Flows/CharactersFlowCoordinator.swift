//
//  CharactersFlowCoordinator.swift
//  MVVMC+Combine
//
//  Created by Davit on 05.03.24.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersViewController() -> CharactersViewController
    func makeCharactersDetailsViewController() -> CharacterDetailsViewController
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
    
    func makeCharactersViewController() -> CharactersViewController {
        let vm = CharactersViewModel()
        return CharactersViewController(viewmodel: vm)
    }
    
    func makeCharactersDetailsViewController() -> CharacterDetailsViewController {
        .init()
    }
}
