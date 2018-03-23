//
//  Exit.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/22/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import Foundation

struct Exit: Codable {
    let toRoomId: String
    let exitDirection: String
    let exitDescription: String
    var locked: Bool
    
    mutating func setLocked(_ locked: Bool) {
        self.locked = locked
    }
}
