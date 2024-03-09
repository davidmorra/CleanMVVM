//
//  AppDIContainer.swift
//  MVVMC+Combine
//
//  Created by Davit on 09.03.24.
//

import Foundation
import Network

final class AppDIContainer {
    let apiClient: ApiClient = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        return ApiClient(session: session)
    }()
    
    func makeCharacteresDIContainer() -> CharacteresDIContainer {
        CharacteresDIContainer(apiClient: apiClient)
    }
}
