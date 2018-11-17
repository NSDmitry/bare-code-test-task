//
//  Product.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import Foundation

struct Product: Decodable {
    var imageUrls: [String]
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrls = "images"
        case name
    }
}
