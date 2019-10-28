//
//  Model.swift
//  TopicClassifier
//
//  Created by M'haimdat omar on 26-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import Foundation
import UIKit

struct Model {
    var text: String
    var color: UIColor
    var secondaryColor: UIColor
    var topic: String
    
    init(text: String, color: UIColor, topic: String, secondaryColor: UIColor) {
        self.text = text
        self.color = color
        self.secondaryColor = secondaryColor
        self.topic = topic
    }
}
