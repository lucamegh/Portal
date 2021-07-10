/**
 * Portal
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import UIKit

public struct ContainerViewControllerTransition {
    
    private let animator: UIViewControllerAnimatedTransitioning
    
    private init(animator: UIViewControllerAnimatedTransitioning) {
        self.animator = animator
    }
    
    func animate(using transitionContext: ContainerViewControllerTransitionContext) {
        animator.animateTransition(using: transitionContext)
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        animator.animationEnded?(transitionCompleted)
    }
}

public extension ContainerViewControllerTransition {
    
    static var `default`: Self {
        .fade(duration: 0.25)
    }
    
    static func fade(duration: TimeInterval) -> Self {
        let fadeAnimator = FadeAnimator(duration: duration)
        return custom(animator: fadeAnimator)
    }
    
    static func custom(animator: UIViewControllerAnimatedTransitioning) -> Self {
        ContainerViewControllerTransition(animator: animator)
    }
}
