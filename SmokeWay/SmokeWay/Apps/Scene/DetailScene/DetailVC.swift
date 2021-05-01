//
//  DetailVC.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/04/25.
//

import UIKit

class DetailVC: UIViewController {

    private var detailViewModel: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureViewModel() {
        let _ = detailViewModel?.transform()
    }
    
    internal static func instantiateDetailVC(selectedPlace: SmokingPlace) -> DetailVC? {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
    
        guard let detailVC = storyboard.instantiateViewController(identifier: "DetailVC") as? DetailVC else {
            return nil
        }
        detailVC.detailViewModel = DetailViewModel(smokingPlace: selectedPlace)
        
        return detailVC
        
    }
    

}
