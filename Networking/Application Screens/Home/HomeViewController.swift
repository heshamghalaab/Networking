//
//  HomeViewController.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import UIKit

class HomeViewController: UIViewController {

    init(){
        super.init(nibName: Self.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "📡 Networking ..."
    }
}
