/**
 * Portal
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import UIKit

public class ContainerViewController: UIViewController {
    
    public override var childForStatusBarStyle: UIViewController? { content }
    
    public var preferredTransition: Transition? = .default
    
    public var content: UIViewController? {
        get { _content }
        set { setContent(newValue, animated: false) }
    }
    
    private var _content: UIViewController?
            
    public init(content: UIViewController? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setContent(_ content: UIViewController?, animated: Bool) {
        self.transition(from: _content, to: content, transition: animated ? preferredTransition : nil)
        _content = content
        setNeedsStatusBarAppearanceUpdate()
    }
    
    public func setContent(_ content: UIViewController?, using transition: Transition?) {
        self.transition(from: _content, to: content, transition: transition)
        _content = content
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func transition(
        from fromViewController: UIViewController?,
        to toViewController: UIViewController?,
        transition: Transition?
    ) {
        if
            let toViewController = toViewController,
            let toView = toViewController.view
        {
            toView.frame = view.bounds
            view.addSubview(toView)
            toView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toView.widthAnchor.constraint(equalTo: view.widthAnchor),
                toView.heightAnchor.constraint(equalTo: view.heightAnchor),
                toView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                toView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            addChild(toViewController)
        }
        
        fromViewController?.willMove(toParent: nil)
        
        func completeTransition() {
            fromViewController?.view.removeFromSuperview()
            fromViewController?.removeFromParent()
            toViewController?.didMove(toParent: self)
        }
        
        guard
            let transition = transition,
            viewIfLoaded?.window != nil
        else {
            return completeTransition()
        }
        
        let context = ContainerViewControllerTransitionContext(
            containerView: view,
            fromViewController: fromViewController,
            toViewController: toViewController,
            completion: { [transition] didComplete in
                completeTransition()
                transition.animationEnded(didComplete)
            }
        )
        
        transition.animate(using: context)
    }
}

public extension ContainerViewController {
    
    struct Transition {
        
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
}

public extension ContainerViewController.Transition {
    
    static var `default`: Self {
        .fade(duration: 0.25)
    }
    
    static func fade(duration: TimeInterval) -> Self {
        let fadeAnimator = FadeAnimator(duration: duration)
        return custom(animator: fadeAnimator)
    }
    
    static func custom(animator: UIViewControllerAnimatedTransitioning) -> Self {
        ContainerViewController.Transition(animator: animator)
    }
}
