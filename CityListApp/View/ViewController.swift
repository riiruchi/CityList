//
//  ViewController.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var cityViewModels: [CityViewModel] = []
    private let cityService: CityServiceProtocol
    
    init(cityService: CityServiceProtocol = CityService()) {
        self.cityService = cityService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            self.cityService = CityService()
            super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCities()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
    }
    
    private func fetchCities() {
        cityService.fetchCities { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self?.cityViewModels = cities.map { CityViewModel(city: $0) }
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch cities:", error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = cityViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityViewModels[indexPath.row]
        let detailVC = CityDetailViewController(city: city)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
