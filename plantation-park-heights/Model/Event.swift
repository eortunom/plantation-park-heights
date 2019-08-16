//
//  Event.swift
//  plantation-park-heights
//
//  Created by Ortuno Marroquin, Eduardo on 8/7/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation

struct Event {
    let name : String
    let startDate : String
    let endDate : String
    let description : String
    
    init(nam : String, start : String, end : String, desc : String) {
        name = nam
        startDate = start
        endDate = end
        description = desc
    }
}
