//
//  Global.swift
//  Imaginato
//
//  Created by Prince Sojitra on 08/12/20.
//  Copyright © 2020 Asha Patel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIView {

  @IBInspectable var cornerRadius: CGFloat {

   get{
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
        return UIColor(cgColor: layer.borderColor!)
    }
    set {
        layer.borderColor = borderColor?.cgColor
    }
  }
}


extension UIView{
    
    func addShadow(){
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
    
    
}

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toDateString(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")-> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MMM, yyyy"
        return dateFormatter.string(from: date)
    }
}


extension UIAlertController {

    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style

        static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }

    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction])
        -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }

            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }

    }

}
