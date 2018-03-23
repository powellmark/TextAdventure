//
//  Room.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/22/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import Foundation

struct Room: Codable {
    let id: String
    let description: String
    let exits: [Exit]
    let items: [Item]
}
