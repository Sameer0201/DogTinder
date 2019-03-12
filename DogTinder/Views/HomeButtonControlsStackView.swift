//
//  HomeButtonControlsStackView.swift
//  DogTinder
//
//  Created by Nagasaki on 18/02/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit

class HomeBottonControlsStackView: UIStackView {

    override init(frame: CGRect){
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let subviews = [#imageLiteral(resourceName: "3 1"),#imageLiteral(resourceName: "3 2") ,#imageLiteral(resourceName: "3 3"), #imageLiteral(resourceName: "3 4"), #imageLiteral(resourceName: "3 5")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subviews.forEach { (v) in
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
