//
//  Names.swift
//  collectionView
//
//  Created by Shrishail Diggi on 07/05/19.
//  Copyright © 2019 Shrishail Diggi. All rights reserved.
//

import Foundation
import Firebase

struct Names {
    
    let dataRef: DatabaseReference?
    let key: String
    let name: String
    
    init(name: String, key: String = "") {
        self.dataRef = nil
        self.key = key
        self.name = name
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String else {
                return nil
        }
        
        self.dataRef = snapshot.ref
        self.key = snapshot.key
        self.name = name
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}
