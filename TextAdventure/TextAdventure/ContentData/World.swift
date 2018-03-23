//
//  World.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/23/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import Foundation

struct World: Codable {
    let rooms: [Room]
    let startRoomId: String
    
    func room(for id: String) -> Room? {
        for room in rooms {
            if room.id == id {
                return room
            }
        }
        
        return nil
    }
    
    func startRoom() -> Room? {
        return room(for: startRoomId)
    }
}
