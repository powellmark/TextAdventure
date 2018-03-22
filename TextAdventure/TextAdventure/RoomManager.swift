//
//  RoomManager.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/22/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import UIKit

class RoomManager: NSObject {
    var currentRoom: Room?
    var world: [String: Room]?
    
    func load() {
        let exit1 = Exit(toRoomId: "002", exitDirection: "north", exitDescription: "A door to the north leads to darkness.", locked: false)
        let exit2 = Exit(toRoomId: "003", exitDirection: "up", exitDescription: "A ladder leads to the loft above.", locked: false)
        let room1Exits = [exit1, exit2]
        let room1 = Room(id: "001", description: "This is a damp room. The windows are covered with tattered rags. There is a bookshelf in the corner that contains moldy rotten tomes. In the haze you can make out what appears to be a loft above.", exits: room1Exits)
        
        let exit3 = Exit(toRoomId: "001", exitDirection: "south", exitDescription: "The doorway to the south leads back to where you came.", locked: false)
        let room2Exits = [exit3]
        let room2 = Room(id: "002", description: "You are in what appears to be a kitchen. Although, it's not certain as all furniture, save a single table, has been removed. There are disconnected pipes poking from the walls.", exits: room2Exits)
        
        let exit4 = Exit(toRoomId: "001", exitDirection: "down", exitDescription: "The only way out is back down the ladder.", locked: false)
        let room3Exits = [exit4]
        let room3 = Room(id: "003", description: "This loft appears to be a study. There is a roll top desk against the far wall and a couch next to it.", exits: room3Exits)
        
        world = [String: Room]()
        world?[room1.id] = room1
        world?[room2.id] = room2
        world?[room3.id] = room3
        currentRoom = room1
    }
    
    func process(_ command: String) -> [String] {
        var components = command.components(separatedBy: " ")
        let verb = components[0]
        components.remove(at: 0)
        
        if verb == "help" {
            return helpCommand()
        } else if verb == "go" {
            return parseGo(components)
        } else {
            return ["\(command) is not a valid command"]
        }
    }
    
    func helpCommand() -> [String] {
        return ["""
        Use [VERB] [NOUN] to interact with the world.
        For example: go north, take sword, drink water.
        
        Available verbs: go, take, use, examine, look, push, drop, drink, eat
        """]
    }
    
    func parseGo(_ parameters: [String]) -> [String] {
        guard parameters.count > 0 else {
            return ["Where do you want to go?"]
        }
        
        let direction = parameters[0]
        
        if let exits = currentRoom?.exits {
            for exit in exits {
                if direction == exit.exitDirection {
                    currentRoom = world?[exit.toRoomId]
                    if let currentRoom = currentRoom {
                        var newRoom = [String]()
                        newRoom.append(currentRoom.description)
                        for exit in currentRoom.exits {
                            newRoom.append(exit.exitDescription)
                        }
                        
                        return newRoom
                    }
                }
            }
        }
        
        return ["You can't go \(direction)"]
    }
}
