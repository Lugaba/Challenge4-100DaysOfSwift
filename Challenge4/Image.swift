//
//  Image.swift
//  Challenge4
//
//  Created by Luca Hummel on 11/08/21.
//

import Foundation

class Image: Codable {
    var imageName: String
    var caption: String
    
    init(imageName: String, caption: String) {
        self.imageName = imageName
        self.caption = caption
    }
}
