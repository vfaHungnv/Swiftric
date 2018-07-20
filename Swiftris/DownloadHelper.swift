//
//  DownloadHelper.swift
//  Demo_Chat
//
//  Created by HungNV on 8/17/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import UIKit
import NCMB
import Alamofire

class DownloadHelper: NSObject {
    static let shared = DownloadHelper()
    
    func downloadImageWithFileName(fileName: String, completionHandler: @escaping(UIImage) -> Void) {
        if let image = Helper.shared.getCachedImageForPath(fileName: fileName) {
            completionHandler(image)
        } else {
            let fileData = NCMBFile.file(withName: fileName, data: nil)
            if let fileData = fileData as? NCMBFile {
                fileData.getDataInBackground({ (data, error) in
                    guard let data = data else { return }
                    if (error == nil) {
                        if let image = UIImage.init(data: data) {
                            Helper.shared.cacheImageThumbnail(image: image, fileName: fileName)
                            completionHandler(image)
                        }
                    }
                }, progressBlock: { (percentDone) in
                
                })
            }
        }
    }
    
    func downloadImageWithURL(urlStr: String, filename: String, completionHandler: @escaping(Bool) -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(filename)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlStr, to: destination).response { response in
            if response.error == nil, let _ = response.destinationURL?.path {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func downloadFileMP3WithURL(urlStr: String, filename: String, completionHandler: @escaping(Bool) -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(filename)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlStr, to: destination).response { response in
            if response.error == nil, let _ = response.destinationURL?.path {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func addFileMusicAndSaveLocalDB(musics: [SongModel], completionHandler: @escaping(Bool) -> Void) {
        for music in musics {
            self.copyFileToDocument(filename: music.fileName, ofType: "png")
            self.copyFileToDocument(filename: music.fileName, ofType: "mp3")
            self.copyFileToDocument(filename: music.fileName, ofType: "lrc")
            LocalDB.shared().addSongInLocalDB(obj: music)
        }
        completionHandler(true)
    }
    
    func copyFileToDocument(filename: String, ofType: String) {
        let desPath: String = Helper.documentFolder() + "/\(filename).\(ofType)"
        if !FileManager.default.fileExists(atPath: filename) {
            let srcPath: String = Bundle.main.path(forResource: filename, ofType: "\(ofType)")!
            do {
                try FileManager.default.copyItem(atPath: srcPath, toPath: desPath)
            } catch let error {
                #if DEBUG
                    print(error.localizedDescription)
                #endif
            }
        }
    }
}
