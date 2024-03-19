//
//  CharactersFlowCoordinator.swift
//  MVVMC+Combine
//
//  Created by Davit on 05.03.24.
//

import UIKit

public protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersViewController(onSelect: @escaping ((Int) -> Void)) -> CharactersViewController
    func makeCharactersDetailsViewController(for characterID: Int) -> CharacterDetailsViewController
}

public class CharactersFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let factory: CharactersFlowCoordinatorDependencies
    
    public init(navigationController: UINavigationController, factory: CharactersFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    public func start() {
        let vc = factory.makeCharactersViewController(onSelect: showDetails)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func showDetails(for characterID: Int) {
        let vc = factory.makeCharactersDetailsViewController(for: characterID)
        navigationController?.pushViewController(vc, animated: true)
    }
}
