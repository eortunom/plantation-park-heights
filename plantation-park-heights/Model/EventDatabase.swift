//
//  Event.swift
//  plantation-park-heights
//
//  Created by Ortuno Marroquin, Eduardo on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation

struct EventDatabase {
    private var events : [Event] = []
    
    mutating func addEvent(item: Event) {
        events.append(item)
    }
    
    func getEvent(i : Int) -> Event {
        return events[i]
    }
    
    mutating func getEvents() -> [Event] {
        return events.reversed()
    }
    
    func numEvents() -> Int {
        return events.count
    }
}
