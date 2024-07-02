//
//  CityService.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import Foundation

protocol CityServiceProtocol {
    func fetchCities(completion: @escaping (Result<[City], Error>) -> Void)
    func fetchCountryList(completion: @escaping (Result<[Country], Error>) -> Void)
}

final class CityService: CityServiceProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchCities(completion: @escaping (Result<[City], Error>) -> Void) {
        guard let url = URL(string: "https://city-list.p.rapidapi.com/api/getCity/iq") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        networkManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                    completion(.success(cityResponse.cities))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCountryList(completion: @escaping (Result<[Country], Error>) -> Void) {
          guard let url = URL(string: "https://city-list.p.rapidapi.com/api/getCountryList") else {
              completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
              return
          }
          
          networkManager.fetchData(url: url) { result in
              switch result {
              case .success(let data):
                  do {
                      let countryResponse = try JSONDecoder().decode(CountryListResponse.self, from: data)
                      completion(.success(countryResponse.countries))
                  } catch {
                      completion(.failure(error))
                  }
              case .failure(let error):
                  completion(.failure(error))
              }
          }
      }
}

struct CountryListResponse: Decodable {
    let countries: [Country]
    
    private enum CodingKeys: String, CodingKey {
        case countries = "0"
    }
}

struct Country: Decodable {
    let id: Int
    let cname: String
    let iso: String
    let phonecode: String
    let iso3: String
}


struct CityResponse: Decodable {
    let cities: [City]
    
    private struct CityWrapper: Decodable {
        let id: Int
        let parent_id: Int?
        let left: Int?
        let right: Int?
        let depth: Int
        let name: String
        let alternames: String
        let country: String
        let a1code: String
        let level: String
        let population: Int
        let lat: String
        let long: String
        let timezone: String
        
        func toCity() -> City {
            return City(id: id, name: name, country: country, population: population, timezone: timezone)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case cities = "0"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cityWrappers = try container.decode([CityWrapper].self, forKey: .cities)
        self.cities = cityWrappers.map { $0.toCity() }
    }
}

struct City: Decodable {
    let id: Int
    let name: String
    let country: String
    let population: Int
    let timezone: String
}

