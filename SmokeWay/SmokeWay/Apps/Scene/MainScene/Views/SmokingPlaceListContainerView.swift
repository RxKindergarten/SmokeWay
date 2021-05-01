//
//  SmokingPlaceListContainerView.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/04/01.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

class SmokingPlaceListContainerView: UIView {

    // MARK:- Field
    let SWIPEVIEW_HEIGHT: CGFloat = 80
    let CELL_HEIGHT: CGFloat = 100
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK:- UIComponets
    var barView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    var swipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeListTableView)
        addSubview(swipeView)
        swipeView.addSubview(barView)
        swipeView.addGestureRecognizer(panGestureRecognizer)
        
        // SwipeView
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: topAnchor),
            swipeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeView.heightAnchor.constraint(equalToConstant: SWIPEVIEW_HEIGHT)
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
    // MARK:- Internal function
    internal func asPanGestureDriver() -> Driver<Expansion> {
        return panGestureRecognizer.rx.event.asDriver().map { [weak self] gesture in
            guard let strongSelf = self else {
                return .move(distance: 0)
            }
            
            let transition = gesture.translation(in: strongSelf.swipeView)
            let velocity = gesture.velocity(in: strongSelf.swipeView)
            gesture.setTranslation(CGPoint.zero, in: strongSelf.swipeView)
            
            // 세로로 움직일 때
            if abs(velocity.y) > abs(velocity.x) {
                let isUp = velocity.y < 0
                if isUp {
                    return strongSelf.moveUp(constant: transition.y, state: gesture.state)
                }
                else {
                    return strongSelf.moveDown(constant: transition.y, state: gesture.state)
                }
            }
            
            return .move(distance: 0)
        }
    }
    
    internal func asItemSelectDriver() -> Driver<IndexPath> {
        return placeListTableView.rx.itemSelected.asDriver()
    }
    
    internal func bindPlaceListViewData(_ sortedInfos: Driver<[SmokingPlace]>) -> Disposable {
        return sortedInfos
            .asObservable()
            .bind(to: self.placeListTableView.rx.items(cellIdentifier: "PlaceListTVCell",
                                                       cellType: PlaceListTVCell.self)){ (index, element, cell) in
                cell.titleLabel.text = element.name
                cell.addressLabel.text = element.name
            }
    }
    // MARK:- Private function
    private func moveUp(constant: CGFloat, state: UIPanGestureRecognizer.State) -> Expansion {
        
        switch state {
        case .cancelled, .ended, .failed:
            return .high
        default:
            return .move(distance: constant)
        }
    }
    
    private func moveDown(constant: CGFloat, state: UIPanGestureRecognizer.State) -> Expansion {
        
        switch state {
        case .cancelled, .ended, .failed:
            return .low
        default:
            return .move(distance: constant)
        }
    }
    
}
