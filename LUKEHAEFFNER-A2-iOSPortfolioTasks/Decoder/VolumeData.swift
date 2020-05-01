//
//  VolumeData.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit
import Foundation
class VolumeData: NSObject, Decodable {
    var books: [DrinkData]?
    
 private enum CodingKeys: String, CodingKey {
    case books = "drinks"
 }
}
