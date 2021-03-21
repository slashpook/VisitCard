//
//  ImageManager.swift
//  VisitCard
//
//  Created by Damien DELES on 17/03/2021.
//

import UIKit

class ImageManager {
    private static var getDocumentsDirectory: URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    class func writeInDocument(image: UIImage, fileName: String, success: (String) -> Void, failure: (Error?) -> Void) {
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            failure(nil)
            return
        }
        do {
            let urlToSave = getDocumentsDirectory.appendingPathComponent(fileName)
            try jpegData.write(to: urlToSave, options: [.atomicWrite, .completeFileProtection])
            success(fileName)
        } catch  {
            failure(error)
        }
    }
    
    class func loadUIImage(fileName: String) -> UIImage {
        let url = getDocumentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            return UIImage(named: "placeholder")!
        }
        
        return image
    }
}
