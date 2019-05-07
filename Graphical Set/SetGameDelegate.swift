//
//  SetGameDelegate.swift
//  Graphical Set
//
//  Created by Selin Denise Acar on 2019-05-07.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import Foundation

protocol SetGameDelegate: NSObjectProtocol {
    func removeCardsFromView(forCardIndices indices: [Int])
}
