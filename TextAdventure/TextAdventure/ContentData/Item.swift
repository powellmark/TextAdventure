//
//  Item.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/23/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import Foundation

struct Item: Codable {
    let ownable: Bool
    let callout: Bool
    let name: String
    let actions: [ItemAction]
    
    func handleAction(_ verb: String) -> [String] {
        for action in actions {
            if action.verb == verb {
                return [action.description]
            }
        }
        
        return ["You can't do that with this item."]
    }
}
