//
//  CountryTableViewCell.swift
//  CityListApp
//
//  Created by Ruchira  on 02/07/24.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let populationLabel = UILabel()
    private let countryLabel = UILabel()
    private let timezoneLabel = UILabel()
    private let cardView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCardView()
        setupLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCardView() {
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowRadius = 5
        cardView.backgroundColor = .white
        contentView.addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    private func setupLabels() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, populationLabel, countryLabel, timezoneLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10)
        ])
    }

    func configure(with viewModel: CityViewModel) {
        nameLabel.text = viewModel.name
        populationLabel.text = viewModel.population
        countryLabel.text = viewModel.country
        timezoneLabel.text = viewModel.timezone
    }
}
