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
        askContentsOfDir()
        lookForFiles()
        saveStringToFile()
        saveArrayToFile()
    }
    
    ///Get User sharing URL
    func docsDir() {
        
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsURL)
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
        let folderName2 = "MyFolder2"
        let subFolderName = "SubFolderName"
        
        ///1. Get the shared File Manager object.
        let fm = FileManager.default
        ///2. Use a FileManager instance to GET a URL pointing at the Documents directory
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        ///3. Generate a REFERENCE to the MyFolder folder from documents’ URL.
        let myFolder = docsURL.appendingPathComponent(folderName)
        let myFolder2 = docsURL.appendingPathComponent(folderName2)
        let subFolder = myFolder.appendingPathComponent(subFolderName)
        ///4. Using that REFERENCE (myfolder), ask the FileManager to create the folder if it doesn’t exist already;
        try! fm.createDirectory(at: myFolder, withIntermediateDirectories: true, attributes: nil)
        try! fm.createDirectory(at: myFolder2, withIntermediateDirectories: true, attributes: nil)
        try! fm.createDirectory(at: subFolder, withIntermediateDirectories: true, attributes: nil)
    }
    
    // Ask files and folders exist within a directory (shallow way).
    func askContentsOfDir() {
        let fm = FileManager.default
        ///GET URL REFERENCE
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let arr = try! fm.contentsOfDirectory(at: docsURL, includingPropertiesForKeys: nil )
        arr.forEach { (url) in
            print(url.lastPathComponent)
//            print(url)
        }
        
        //Looking for dir in a dirctory
        ///Note: contentsOfDirectory() method doesn't permits you to decline to dive into subdirectory.
        let docsURL2 = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let arr2 = try! fm.contentsOfDirectory(at: docsURL2, includingPropertiesForKeys: nil)
        for url in arr2 where url.lastPathComponent == "SubFolderName" {
            print("askContentsOfDir(): \(url.lastPathComponent)")
        }
    }
    
    // Looking for Files in a dirctory by means of a directory enumerator (deep way).
    ///(This is efficient with regards to memory, because you are handed just one file reference at a time.)
    func lookForFiles() {
        let fm = FileManager.default
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dir = fm.enumerator(at: docsURL, includingPropertiesForKeys: nil)!
        
        for case let f as URL in dir where f.pathExtension == "txt" {
            print(f.lastPathComponent)
        }
        
        
        //Note: Directory Enumerator permits you to decline to dive into a particular subdirectory.
        let docsURL2 = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dir2 = fm.enumerator(at: docsURL2, includingPropertiesForKeys: nil)!
        for case let url as URL in dir2 where url.lastPathComponent == "SubFolderName" {
            print("lookForFiles(): \(url.lastPathComponent)")
        }
        
    }
    
    ///at: "docsDir" means documentDirectory; "tempDir" means temporaryDirectory;
    ///for: "Folder Name"
    func searchFolder(at rootDir: String, for name: String?, handler: @escaping (_ fm: FileManager, _ url: URL) ->()) {
        let fm = FileManager.default
                
        switch rootDir {
        case "docsDir":
            let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dirs = fm.enumerator(at: docsURL, includingPropertiesForKeys: nil)!
            
            if let name = name {
                for case let url as URL in dirs where url.lastPathComponent == name {
                    print("search folder: \(name) is at path: \(url)")
                    //Calling escaping closure
                    handler(fm, url)
                }
            }
            else {
                print("Didn't enter folder name")
                handler(fm, docsURL)
            }
        case "tempDir":
            let temp = fm.temporaryDirectory
            let dirs = fm.enumerator(at: temp, includingPropertiesForKeys: nil)!
            
            if let name = name {
                for case let url as URL in dirs where url.lastPathComponent == name {
                    print("search folder: \(name) is at path: \(url)")
                    handler(fm, url)
                }
            }
            else {
                print("Didn't enter folder name")
                handler(fm, temp)
            }
        default:
            print("Can not find the folder: \(String(describing: name))")
            return
        }
    }
    
    // Saving NSString Object to a text file
    func saveStringToFile() {
        
        searchFolder(at: "docsDir", for: "MyFolder") { (fm, url) in
            
            do {
                try "My name is Leslie2".write(to: url.appendingPathComponent("file2.txt"), atomically: true, encoding: .utf8)
            } catch let err as NSError {
                print(err.userInfo)
            }
        }
    }
    
    // Saving NSArray and NSDictionary to a plist File
    func saveArrayToFile() {
        
        searchFolder(at: "tempDir", for: nil) { (fm, url) in
            do {
                let arr = ["Manny", "Moe", "Jack"]
                let f = url.appendingPathComponent("pep.plist")
                try (arr as NSArray).write(to: f)
            } catch let err as NSError {
                print(err.userInfo)
            }
        }
        
        searchFolder(at: "tempDir", for: "pep.plist") { (fm, url) in
            
        }
    }
    
}

