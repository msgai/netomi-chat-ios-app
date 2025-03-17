//
//  CommonFunctions.swift
//  NetomiSampleApp
//
//  Created by Akash Gupta on 14/11/24.
//

import UIKit

class CommonFunctions {
    
    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            SKToast.backgroundStyle(UIBlurEffect.Style.extraLight)
            SKToast.messageFont(UIFont.systemFont(ofSize: 14, weight: .medium))
            SKToast.messageTextColor(UIColor.black)
            SKToast.show(withMessage: msg, completionHandler: {
                completion?()
            })
        }
    }
    
    /// Stringify the json object
    static func jsonToString(json: [String: Any]) -> String? {
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data, encoding: .utf8)?
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "", with: "")// the data will be converted to the string
            return convertedString
        } catch let myJSONError {
            debugPrint(myJSONError)
            return nil
        }
    }
}
