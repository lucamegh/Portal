/**
 * Portal
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import UIKit

class ContainerViewControllerTransitionContext: NSObject, UIViewControllerContextTransitioning {
    
    let isAnimated = true
    
    let isInteractive = false
    
    let transitionWasCancelled = false
    
    let targetTransform = CGAffineTransform.identity
    
    let presentationStyle = UIModalPresentationStyle.custom
    
    let containerView: UIView
    
    private let fromViewController: UIViewController?
    
    private let toViewController: UIViewController?
    
    private let completion: (Bool) -> Void
    
    init(
        containerView: UIView,
        fromViewController: UIViewController?,
        toViewController: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        self.containerView = containerView
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.completion = completion
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        switch key {
        case .from:
            return fromViewController
        case .to:
            return toViewController
        default:
            return nil
        }
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        switch key {
        case .from:
            return fromViewController?.view
        case .to:
            return toViewController?.view
        default:
            return nil
        }
    }
    
    func initialFrame(for viewController: UIViewController) -> CGRect {
        containerView.frame
    }
    
    func finalFrame(for viewController: UIViewController) -> CGRect {
        containerView.frame
    }
    
    func completeTransition(_ didComplete: Bool) {
        completion(didComplete)
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {}
    
    func finishInteractiveTransition() {}
    
    func cancelInteractiveTransition() {}
    
    func pauseInteractiveTransition() {}
}
