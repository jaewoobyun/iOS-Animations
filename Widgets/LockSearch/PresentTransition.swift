//
//  PresentTransition.swift
//  Widgets
//
//  Created by 변재우 on 20190118//.
//  Copyright © 2019 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

class PresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
  
  var context: UIViewControllerContextTransitioning?
  var animator: UIViewPropertyAnimator?
  
  var auxAnimations: (() -> Void)?
  var auxAnimationsCancel: (() -> Void)?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.75
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    transitionAnimator(using: transitionContext).startAnimation()
  }
  
  func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    let duration = transitionDuration(using: transitionContext)
    
    let container = transitionContext.containerView
    let to = transitionContext.view(forKey: .to)!
    
    container.addSubview(to)
    
    to.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
      .concatenating(CGAffineTransform(translationX: 0.0, y: 200))
    to.alpha = 0
    
    let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: nil)
    animator.addAnimations({
      to.transform = CGAffineTransform(translationX: 0.0, y: 100)
    }, delayFactor: 0.15)
    
    animator.addAnimations({
      to.alpha = 1.0
    }, delayFactor: 0.5)
    
//    animator.addCompletion { (_) in
//      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    }
    
    animator.addCompletion { (position) in
      switch position {
      case .end:
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      default:
        transitionContext.completeTransition(false)
        self.auxAnimationsCancel?()
      }
      
    }
    
    if let auxAnimations = auxAnimations {
      animator.addAnimations(auxAnimations)
    }
    
    self.animator = animator
    self.context = transitionContext
    
    animator.addCompletion { [unowned self] (_) in
      self.animator = nil
      self.context = nil
    }
    
    animator.isUserInteractionEnabled = true
    
    return animator
  }
  
  func interruptTransition() {
    guard let context = context else {
      return
    }
    context.pauseInteractiveTransition()
    pause()
  }
  
  func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    return transitionAnimator(using: transitionContext)
  }
  
  
}
