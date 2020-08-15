//
//  Array+Only.swift
//  Memorize
//
//  Created by David Burghoff on 01.08.20.
//

import Foundation

extension Array {
    var only: Element?{
        count == 1 ? first : nil
    }
}
