//
//  CityDetailViewController.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import UIKit

import UIKit

class CityDetailViewController: UIViewController {
    private let city: CityViewModel
    private var country: Country?
    
    private let tableView = UITableView()

    init(city: CityViewModel) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCountry()
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
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailCell")
    }
    
    private func fetchCountry() {
        print("Fetching country list for city: \(city.name), country code: \(city.country)")
        CityService().fetchCountryList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    print("Fetched countries: \(countries)")
                    // Remove "Country: " prefix from city.country
                    let countryCode = self?.city.country.replacingOccurrences(of: "Country: ", with: "")
                    self?.country = countries.first(where: { $0.iso == countryCode })
                    print("Matched country: \(self?.country?.cname ?? "None")")
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch country:", error)
                }
            }
        }
    }
}

extension CityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 1 header row + 2 detail rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderTableViewCell
            cell.leftHeaderLabel.text = "Country"
            cell.rightHeaderLabel.text = "City Details"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            if indexPath.row == 1 {
                cell.leftDetailLabel.text = country?.cname ?? "Unknown"
                cell.rightDetailLabel.text = city.name
            } else {
                cell.leftDetailLabel.text = ""
                cell.rightDetailLabel.text = "Population: \(city.population)"
            }
            return cell
        }
    }
}
