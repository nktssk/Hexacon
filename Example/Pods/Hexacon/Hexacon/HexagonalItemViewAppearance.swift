//
//  HexagonalViewItemAppearance.swift
//  Hexacon
//
//  Created by Gautier Gdx on 05/03/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

public enum HexagonalAnimationType { case Spiral, Circle, None }

public struct HexagonalItemViewAppearance {
    
    //item appearance
    public var needToConfigureItem: Bool
    public var itemSize: CGFloat
    public var itemSpacing: CGFloat
    public var itemBorderWidth: CGFloat
    public var itemBorderColor: UIColor
    
    //animation
    public var animationType: HexagonalAnimationType
    public var animationDuration: NSTimeInterval
    
    static func defaultAppearance() -> HexagonalItemViewAppearance {
        return HexagonalItemViewAppearance(needToConfigureItem: false,
            itemSize: 50,
            itemSpacing: 10,
            itemBorderWidth: 5,
            itemBorderColor: UIColor.grayColor(),
            animationType: .Circle,
            animationDuration: 0.2)
    }
}

