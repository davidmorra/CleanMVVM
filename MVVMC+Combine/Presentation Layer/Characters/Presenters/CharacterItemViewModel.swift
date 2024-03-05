//
//  CharacterItemViewModel.swift
//  MVVMC+Combine
//
//  Created by Davit on 03.03.24.
//

import Domain

struct CharacterItemViewModel: Hashable {
    let id: Int
    let name: String
    let imageUrl: String
    let species: String
    
    init(_ model: Character) {
        self.id = model.id
        self.name = model.name
        self.imageUrl = model.image
        self.species = model.species
    }
    
    init(id: Int, name: String, imageUrl: String, species: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.species = species
    }
}
