//
//  MainVC.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/03/22.
//

import UIKit

import Firebase
import RxSwift
import RxCocoa

class MainVC: UIViewController {
    
    // MARK:-  UI Components
    var placeListContainerView: SmokingPlaceListContainerView = {
        let view = SmokingPlaceListContainerView(frame: .zero)
        return view
    }()
    

    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        // Do any additional setup after loading the view.
    }
    
    private func initLayout() {
        view.addSubview(placeListContainerView)
        
        NSLayoutConstraint.activate([
            placeListContainerView.topAnchor.constraint(equalTo: view.topAnchor,
                                                        constant: view.frame.height - placeListContainerView.BARVIEW_HEIGHT),
            placeListContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeListContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeListContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
