/**
 * Portal
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import UIKit

public class ContainerViewController: UIViewController {
    
    public override var childForStatusBarStyle: UIViewController? { content }
    
    public var transition: ContainerViewControllerTransition? = .default
    
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
        transition(from: _content, to: content, animated: animated)
        _content = content
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func transition(
        from fromViewController: UIViewController?,
        to toViewController: UIViewController?,
        animated: Bool
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
            animated,
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
