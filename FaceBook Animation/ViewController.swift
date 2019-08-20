//
//  ViewController.swift
//  FaceBook Animation
//
//  Created by Youssef on 10/30/18.
//  Copyright © 2018 Youssef. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let bgImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        return imageView
        
    }()
    
    var iconContainerView: UIView = {
        let container  = UIView()
        container.backgroundColor = .white
        
    /*
        let redV = UIView()
        redV.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        let blueV = UIView()
        blueV.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let yellowV = UIView()
        yellowV.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        let greenV = UIView()
        greenV.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
         
        //let arrengedSubViews = [redV, blueV, yellowV, greenV]
    */
        
        let padding: CGFloat = 8
        let iconHight: CGFloat = 60
        
    /*
         // Array For Colors
         let arrengedSubViews = [UIColor.red, UIColor.black, UIColor.blue, UIColor.gray].map({ (color) -> UIView in
            let v = UIView()
            v.backgroundColor = color
            v.layer.cornerRadius = iconHight / 2
            return v
        })
    */
        let imges = [#imageLiteral(resourceName: "Logo"),#imageLiteral(resourceName: "Logo"),#imageLiteral(resourceName: "Logo"),#imageLiteral(resourceName: "Logo"),#imageLiteral(resourceName: "Logo"), #imageLiteral(resourceName: "Logo")]
        let arrengedSubViews = imges.map({ (image) -> UIView in
            let img = UIImageView(image: image, highlightedImage: nil)
            img.layer.cornerRadius = iconHight / 2
            img.isUserInteractionEnabled = true
            return img
        })
        
        let stackV = UIStackView(arrangedSubviews: arrengedSubViews)
        stackV.distribution = .fillEqually
        stackV.spacing = padding
        stackV.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackV.isLayoutMarginsRelativeArrangement = true
        
        container.addSubview(stackV)

        let numOfIcons = CGFloat(arrengedSubViews.count)
        let width = numOfIcons * iconHight + (numOfIcons + 1) * padding
        
        container.frame = CGRect(x: 0, y: 0, width: width, height: iconHight + 2 * padding)
        container.layer.cornerRadius = container.frame.height / 2
        
        // Container Shadow
        container.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackV.frame = container.frame
        
        return container
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        setUpLongPressGeasture()
        
        // add face book image
             view.addSubview(bgImage)
             bgImage.frame = view.frame
    }

    override var prefersStatusBarHidden: Bool { return true }
    
    fileprivate func setUpLongPressGeasture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (img) in
                    img.transform = .identity
                })
                
                self.iconContainerView.transform = self.iconContainerView.transform.translatedBy(x: 0, y: 50)//self.iconContainerView.frame.height)
                self.iconContainerView.alpha = 0
            }, completion: { (_) in
                self.iconContainerView.removeFromSuperview()
            })
            
            }
        else if gesture.state == .changed {
            handleGestureChange(gesture: gesture)
        }
        
    }
    
    fileprivate func handleGestureChange(gesture: UILongPressGestureRecognizer) {
        let pressedLoction = gesture.location(in: self.iconContainerView)
        
        let fixedYLocation = CGPoint(x: pressedLoction.x, y: self.iconContainerView.frame.height / 2)
        
        let hitTest = iconContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTest is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (img) in
                    img.transform = .identity
                })
                
                hitTest?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    
    
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        
        view.addSubview(iconContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        let centeredX = (view.frame.width - iconContainerView.frame.width) / 2
        
        
        // alfa to 0
        iconContainerView.alpha = 0
        self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            // alfa to 1
            self.iconContainerView.alpha = 1
            
            // Transform the icon container
            self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconContainerView.frame.height)
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Dispose of any resources that can be recreated.")
    }


}

