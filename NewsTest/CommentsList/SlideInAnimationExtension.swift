//
//  SlideInAnimationExtension.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

extension SlideInViewController {
    
    //handles the user tap gesture
    //@objc is needed to call the function with #selector
    @objc func handleViewTap(recogizer:UITapGestureRecognizer){
        if recogizer.state == .ended {
            animateTransition(duration: 1)
        }
    }
    
    //handles the user pan gesture
    //@objc is needed to call the function with #selector
    @objc func handleViewPan(recogizer:UIPanGestureRecognizer){
        if parentFrameHeight == nil { return }
        
        switch recogizer.state {
        case .began:
            
            startTransition(duration: 1)
        case .changed:
            let translation = recogizer.translation(in: handleArea)
            var fractionCompleted = translation.y / SlideInViewController.viewHeight
            fractionCompleted = isSlidingIn ? fractionCompleted : -fractionCompleted
            updateTransition(fractionCompleted)
        case .ended:
            continueTransition()
        default:
            break
        }
    }
    
    func animateTransition(duration:TimeInterval){
        if runningAnimations.isEmpty {
            let frameAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch self.nextState {
                case .expanded:
                    self.view.frame.origin.y = self.parentFrameHeight! - SlideInViewController.viewHeight
                case .collapsed:
                    self.view.frame.origin.y = self.parentFrameHeight! - SlideInViewController.handleHeight
                }
            }
            
            frameAnimation.addCompletion { _ in
                self.isSlidingIn = !self.isSlidingIn
                self.runningAnimations.removeAll()
            }
            
            frameAnimation.startAnimation()
            runningAnimations.append(frameAnimation)
            
            guard let effectView = parentEffectView else { return }
            let blurAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch self.nextState {
                case .expanded:
                    effectView.effect = UIBlurEffect(style: .light)
                case .collapsed:
                    effectView.effect = nil
                }
            }
            blurAnimation.startAnimation()
            runningAnimations.append(blurAnimation)
        }
    }
    
    func startTransition(duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransition(duration: duration)
        }
        
        for animation in runningAnimations {
            animation.pauseAnimation()
            animationProgressWhenInterrupted = animation.fractionComplete
        }
    }
    
    func updateTransition(_ fractionCompleted:CGFloat) {
        for animation in runningAnimations {
            animation.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueTransition() {
        for animation in runningAnimations {
            animation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
