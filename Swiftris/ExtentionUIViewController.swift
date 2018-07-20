//
//  ExtentionUIViewController.swift
//  Demo_Chat
//
//  Created by Nguyen Van Hung on 2/18/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func startLoading() {
        self.pleaseWait()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.view.isUserInteractionEnabled = true
    }
    
    //MARK:- Set border
    func setBorderButton(btn: UIButton, isCircle: Bool) {
        let corner = isCircle ? btn.frame.size.width/2 : btn.frame.size.height/2
        btn.layer.cornerRadius = corner
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.white.cgColor
        btn.clipsToBounds = true
    }
    
    func setBorderImageView(imgView: UIImageView, isCircle: Bool) {
        let corner = isCircle ? imgView.frame.size.width/2 : 20
        imgView.layer.cornerRadius = corner
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.clipsToBounds = true
    }
    
    func setButtonFontBold(btn: UIButton, size: FontSize) {
        btn.titleLabel?.font = Theme.shared.font_primaryBold(size: size)
    }
    
    //MARK:- Show Alert action sheet
    func showAlertSheet(title: String,msg: String,actions:[UIAlertAction]) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Set placeholder
    func setAttributedForTextField(txt: UITextField, placeholder: String, font: UIFont, delegate: UITextFieldDelegate) {
        txt.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
        txt.font = font
        txt.textColor = UIColor.white
        txt.delegate = delegate
    }
    
    //MARK:- Change title Navigation Controller
    func changeTitle(title: String) {
        self.navigationItem.title = title
    }
    
    //MARK:- Navigation
    func setupNavigationBar(vc: UIViewController, title: String? = nil, leftText: String? = nil, leftImg: UIImage? = nil, leftSelector: Selector? = nil, rightText: String? = nil, rightImg: UIImage? = nil, rightSelector: Selector? = nil, isDarkBackground: Bool? = false, isTransparent: Bool? = false) -> Void {
        
        vc.navigationItem.hidesBackButton = true
        
        if title != nil {
            vc.navigationItem.title = title
            vc.navigationController?.isNavigationBarHidden = false
        } else {
            vc.navigationController?.isNavigationBarHidden = true
        }
        
        let textColor = isDarkBackground! ? UIColor.white : UIColor.black
        let textAttributes = [NSForegroundColorAttributeName: textColor, NSFontAttributeName: Theme.shared.font_primaryRegular(size: .small)]
        
        vc.navigationController?.navigationBar.tintColor = textColor
        vc.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Left
        if leftImg != nil && leftSelector != nil {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImg, style: .plain, target: vc, action: leftSelector)
        } else if leftText != nil && leftSelector != nil {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftText, style: .plain, target: vc, action: leftSelector)
            vc.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
            vc.navigationItem.leftBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        } else {
            vc.navigationItem.leftBarButtonItem = nil
        }
        
        //Right
        if rightImg != nil && rightSelector != nil {
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImg, style: .plain, target: vc, action: rightSelector)
        } else if rightText != nil && rightSelector != nil {
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightText, style: .plain, target: vc, action: rightSelector)
            vc.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
            vc.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        } else {
            vc.navigationItem.rightBarButtonItem = nil
        }
        
        if isTransparent != nil && isTransparent! == true {
            vc.navigationController?.navigationBar.isTranslucent = true
            vc.navigationController?.navigationBar.barTintColor = Theme.shared.color_App()
        } else {
            vc.navigationController?.navigationBar.isTranslucent = false
            vc.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            vc.navigationController?.navigationBar.shadowImage = nil
        }
    }
}
