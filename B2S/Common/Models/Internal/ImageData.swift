//
//  ImageData.swift
//  B2S
//
//  Created by Egor Sakhabaev on 12.07.2021.
//

import Foundation

struct ImageData: Codable {
    let url: String
    var data: Data?
    let base64: String
}
