//
//  DetailInformationViewController.swift
//  MyITunes
//
//  Created by 하연주 on 8/11/24.
//

import UIKit

final class DetailInformationViewController : UIViewController {
    // MARK: - UI
    // MARK: - Properties
    var detailData : ItunesSearchResult?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        print("❤️",detailData)
        
    }
    // MARK: - SetupDelegate
    // MARK: - AddTarget
    private func setupAddTarget() {
    }
    // MARK: - EventSelector
    // MARK: - SetupUI
    // MARK: - APIFetch
    // MARK: - PageTransition
}
