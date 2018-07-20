//
//  Helper.swift
//  Demo_Chat
//
//  Created by Nguyen Van Hung on 2/13/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation

func delay(time: Double, clouser: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) { 
        clouser()
    }
}

class Helper: NSObject {
    static let shared = Helper()
    var cache = NSCache <AnyObject, AnyObject>()
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func saveUserDefault(key: String, value: Any) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getUserDefault(key: String) -> AnyObject? {
        let obj = UserDefaults.standard.object(forKey: key) as AnyObject?
        return obj
    }
    
    func removeUserDefault(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func viewWithImgName(img: UIImage) -> UIView {
        let imgView = UIImageView(image: img)
        imgView.contentMode = .center
        
        return imgView
    }
    
    func currentTime() -> String{
        let dateFormatter : DateFormatter = self.dateFormatter()
        let date : Date = Date()
        
        return (dateFormatter.string(from: date as Date))
    }
    
    func convertReleaseDateFormat(stringDate: String) -> String {
        let dateFormatter : DateFormatter = self.dateFormatter()
        let date: Date = dateFormatter.date(from: stringDate)!
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return dateFormatter.string(from: date)
    }
    
    func dateFormatter() -> DateFormatter{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return dateFormatter
    }
    
    //MARK:- Cached image
    func getCachedImageForPath(fileName: String) -> UIImage? {
        var imgResult = cache.object(forKey: fileName as AnyObject) as? UIImage
        if (imgResult != nil) {
            return imgResult
        }
        
        let imagePath = self.pathForFileName(fileName: fileName)
        imgResult = UIImage.init(contentsOfFile: imagePath)
        
        if (imgResult != nil) {
            cache.setObject(imgResult!, forKey: fileName as AnyObject)
        }
        
        return imgResult
    }
    
    func pathForFileName(fileName: String) -> String {
        let fileManager = FileManager.default
        let strPath = self.cacheDirectoryPath()
        
        if !fileManager.fileExists(atPath: strPath) {
            do {
                try fileManager.createDirectory(atPath: strPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                #if DEBUG
                    print("No create folder")
                #endif
            }
        }
        let imagePath = strPath.appending("/\(fileName)")
        
        return imagePath
    }
    
    func cacheDirectoryPath() -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory , .userDomainMask, true).last
        if let cacheDirectory = cacheDirectory {
            let path = cacheDirectory.appending("/HuCaChat")
            return path
        }
        return cacheDirectory ?? ""
    }
    
    func cacheImageThumbnail(image: UIImage, fileName: String) {
        cache.setObject(image, forKey: fileName as AnyObject)
        let imagePath = self.pathForFileName(fileName: fileName)
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
        } catch let error {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    //MARK:- Language code
    func currentLanguageCode() -> String {
        var currentLanguage: String = ""
        let languageHaveSaved = self.getUserDefault(key: LANGUAGE_KEY)
        
        if let languageHaveSaved = languageHaveSaved as? String {
            currentLanguage = languageHaveSaved
            return currentLanguage
        }
        
        currentLanguage = LANGUAGE_CODE_AUTO
        self.saveUserDefault(key: LANGUAGE_KEY, value: currentLanguage as AnyObject)
        return currentLanguage
    }
    
    //MARK:- Folder Document
    private static var docFolder: String = ""
    public static func documentFolder() -> String {
        if docFolder == "" {
            docFolder = (try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)).path
        }
        return docFolder
    }
    
    func saveImageWithPath(image: UIImage, imgPath: String) {
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: imgPath), options: .atomic)
        } catch let error {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    //MARK:- Version app
    func lastVersion() -> String {
        let obj = self.getUserDefault(key: kLastVersion)
        if obj == nil {
            let version = self.getVersionOfApp()
            self.saveUserDefault(key: kLastVersion, value: version)
            return version
        }
        
        return obj as! String
    }
    
    func getVersionOfApp() -> String {
        let info = Bundle.main.infoDictionary
        if let version = info?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    //MARK:- Compare version device
    func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
    }
    
    func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
    }
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
    }
}
