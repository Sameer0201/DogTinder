//
//  SettingsCell.swift
//  DogTinder
//
//  Created by Nagasaki on 18/03/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    class SettingsTextField: UITextField {
        
        // same concept as before
        // create text in rect with spacing in the front
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
    
    let textField: UITextField = {
        let tf = SettingsTextField()
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
