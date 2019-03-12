//
//  Bindable.swift
//  DogTinder
//
//  Created by Nagasaki on 05/03/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
