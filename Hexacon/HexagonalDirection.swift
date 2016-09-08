//
//  HexagonalDirection.swift
//  Hexacon
//
//  Created by Gautier Gdx on 05/03/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

enum HexagonalDirection: Int {
    
    case right
    case rightUp
    case leftUp
    case left
    case leftDown
    case rightDown
    
    /**
     increment the enum to the next move, if it reach the end it come back a the beggining
     */
    mutating func move()  {
        if self != .rightDown {
            self = HexagonalDirection(rawValue: self.rawValue + 1)!
        } else {
            self = .right
        }
    }
    
    /**
     this this all the direction we can found in an hexagonal layout following the axial coordinate
     it's used to move to the next center on the grid
     
     - returns: a point diving the direction of the new center
     */
    func direction() -> CGPoint {
        
        let horizontalPadding: CGFloat = 1.2
        let verticalPadding: CGFloat = 1
        
        switch self {
            case .right:
                return CGPoint(x: horizontalPadding,y: 0)
            case .rightUp:
                return CGPoint(x: horizontalPadding/2,y: -verticalPadding)
            case .leftUp:
                return CGPoint(x: -horizontalPadding/2,y: -verticalPadding)
            case .left:
                return CGPoint(x: -horizontalPadding,y: 0)
            case .leftDown:
                return CGPoint(x: -horizontalPadding/2,y: verticalPadding)
            case .rightDown:
                return CGPoint(x: horizontalPadding/2,y: verticalPadding)
        }
    }
}
