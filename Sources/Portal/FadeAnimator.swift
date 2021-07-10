/**
 * Portal
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.transition(
            with: transitionContext.containerView,
            duration: transitionDuration(using: transitionContext),
            options: [
                .transitionCrossDissolve,
                .allowUserInteraction
            ],
            animations: {
                transitionContext.view(forKey: .from)
                    .map { $0.removeFromSuperview() }
                transitionContext.view(forKey: .to)
                    .map(transitionContext.containerView.addSubview)
            },
            completion: transitionContext.completeTransition
        )
    }
}
