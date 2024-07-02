//
//  CityListViewModel.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import Foundation

struct CityViewModel {
    let name: String
    let population: String
    let country: String
    let timezone: String
    
    init(city: City) {
        self.name = city.name
        self.population = "Population: \(city.population)"
        self.country = "Country: \(city.country)"
        self.timezone = "Timezone: \(city.timezone)"
    }
}
