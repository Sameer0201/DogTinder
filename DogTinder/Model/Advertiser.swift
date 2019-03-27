//
//  Advertiser.swift
//  DogTinder
//
//  Created by Nagasaki on 21/02/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel{
    //for ads
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    //converts ad to cardViewModel
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(uid: "", imageNames: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
    }
}
