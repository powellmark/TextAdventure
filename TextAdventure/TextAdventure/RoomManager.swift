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
    var world: World?
    
    func load(from filename: String) {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let jsonData = contents.data(using: .utf8)!
                let decoder = JSONDecoder()
                world = try! decoder.decode(World.self, from: jsonData)
                currentRoom = world?.startRoom()
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
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
                    currentRoom = world?.room(for: exit.toRoomId)
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
