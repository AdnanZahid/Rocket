//
//  Anton.swift
//  Rocket
//
//  Created by Mnet on 5/23/20.
//  Copyright © 2020 Rocket. All rights reserved.
//

import Foundation

class Anton {
    func predict (distance: CGFloat,
                  upperBound: CGFloat,
                  lowerBound: CGFloat,
                  yPosition: CGFloat,
                  yVelocity: CGFloat ) -> Bool {
        
        let shouldJump = Bool.random()
        
        return shouldJump
    }
}
