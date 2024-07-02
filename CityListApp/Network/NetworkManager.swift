//
//  NetworkManager.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("city-list.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue("7d5401da33msha70dc53add95202p1e6c5fjsn3a96dbf4bd87", forHTTPHeaderField: "x-rapidapi-key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
