//
//  CountryListViewModel.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import Foundation

class CountryListViewModel {
    var countries : [Country] = []
    
    func fetchCountries(completion : @escaping () -> Void) {
        NetworkManager.shared.fetchCountries {[weak self] result in
            switch result {
            case .success(let countries):
                self?.countries = countries
                completion()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
