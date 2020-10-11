//
//  ViewController.swift
//  Docs20201010
//
//  Created by leslie on 10/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        docsDir()
//        appSuppDir()
        createMyFolder()
    }
    
    ///Get User sharing URL
    func docsDir() {
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            //error
        }
    }
    
    //Get Private URL
    func appSuppDir() {
        do {
            let fm = FileManager.default
            let suppURL = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            ///Prevent from backup
            var rv = URLResourceValues()
            rv.isExcludedFromBackup = true
//            try myFileURL.setResourcevalues(rv)
        } catch {
            // error
        }
        
    }
    
    // Create a folder 'MyFolder'
    func createMyFolder() {
        let folderName = "MyFolder"
        ///1. Get the shared File Manager object.
        let fm = FileManager.default
        ///2. Use a FileManager instance to GET a URL pointing at the Documents directory
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        ///3. Generate a REFERENCE to the MyFolder folder from documents’ URL.
        let myFolder = docsURL.appendingPathComponent(folderName)
        ///4. Using that REFERENCE (myfolder), ask the FileManager to create the folder if it doesn’t exist already;
        try! fm.createDirectory(at: myFolder, withIntermediateDirectories: true, attributes: nil)
    }
    
}

