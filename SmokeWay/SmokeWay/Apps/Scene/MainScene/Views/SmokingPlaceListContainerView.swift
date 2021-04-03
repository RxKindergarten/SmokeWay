//
//  SmokingPlaceListContainerView.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/04/01.
//

import UIKit

class SmokingPlaceListContainerView: UIView {

    var barView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    var swipeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var placeListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "PlaceListTVCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PlaceListTVCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        placeListTableView.dataSource = self
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeListTableView)
        addSubview(swipeView)
        swipeView.addSubview(barView)
        
        // SwipeView
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: topAnchor),
            swipeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeView.heightAnchor.constraint(equalToConstant: 50)
        ])
        // BarView
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 5),
            barView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor),
            barView.widthAnchor.constraint(equalToConstant: 50),
            barView.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        // ListTableView
        NSLayoutConstraint.activate([
            placeListTableView.topAnchor.constraint(equalTo: swipeView.bottomAnchor),
            placeListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
        // Make Round
        clipsToBounds = true
        layer.cornerRadius = 25
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setBorder(borderColor: .lightGray, borderWidth: 1)
        
        barView.makeRounded(cornerRadius: 2.5)
    }
}

extension SmokingPlaceListContainerView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListTVCell", for: indexPath)
                as? PlaceListTVCell else { return UITableViewCell()}
        
        return cell
    }
}
