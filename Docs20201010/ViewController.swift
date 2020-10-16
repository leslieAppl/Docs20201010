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
        
        print()
        saveStringToFile()
        saveArrayToFile()
        
        print()
        createAndSavePersonAsAFile()
        retrieveSavedPerson()
        
        print()
        savePersonToFile()
        retrieveSavedPerson2()
        
        print()
        savePersonToFile3()
        retrieveSavedPerson3()
        
        print()
        saveDataIntoFileWrapper()
        doRead()
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
    
    //Look for all files in the documents folder
    func lookAllFiles() {
        
        let fm = FileManager.default
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dirs = fm.enumerator(at: docsURL, includingPropertiesForKeys: nil)!
        
        for case let dir as URL in dirs {
            let last = dir.lastPathComponent
            var last2 = dir.deletingLastPathComponent().lastPathComponent
            print("Listing directory enumerator: \(last2)/\(last)")
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
        
        do {
            let arr = ["Manny", "Moe", "Jack"]
            let temp = FileManager.default.temporaryDirectory
            let f = temp.appendingPathComponent("pep.plist")
            try (arr as NSArray).write(to: f)
        } catch let err as NSError {
            print(err.userInfo)
        }
        
        searchFolder(at: "tempDir", for: "pep.plist") { (fm, url) in
            
        }
    }
    
    //Creating, configuring, and saving a Person instance as a file.
    //Put Encoded Data into Text File.
    func createAndSavePersonAsAFile() {
        let fm = FileManager.default
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let moi = Person(firstName: "Choo", lastName: "Leslie")
        ///Encodes an object graph with the given root object into a data representation, optionally requiring secure coding.
        ///To prevent the possibility of encoding an object that NSKeyedUnarchiver can’t decode, set requiresSecureCoding to true whenever possible. This ensures that all encoded objects conform to NSSecureCoding.
        let moiData = try! NSKeyedArchiver.archivedData(withRootObject: moi, requiringSecureCoding: true)
        
        ///A Reference to the File's URL
        let moiFile = docsURL.appendingPathComponent("moi.txt")
        ///Writes the contents of the data buffer to a location.
        try! moiData.write(to: moiFile, options: .atomic)
        
        lookAllFiles()
    }
    
    //Retrieve the saved Person
    func retrieveSavedPerson() {
        let fm = FileManager.default
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        ///A Reference to the File's URL
        let moiFile = docsURL.appendingPathComponent("moi.txt")
        ///A  byte buffer in memory.
        ///You can create empty or pre-populated buffers from a variety of sources and later add or remove bytes.
        let personData = try! Data(contentsOf: moiFile)
        
        let person = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Person.self, from: personData)!
        print("Retrieved Person Object: \(String(describing: person))")
    }
    
    //Save Person to File Using Codable Protocol
    //Put Encoded Data into Text File
    func savePersonToFile() {
        
        let fm = FileManager.default
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        ///Person Object
        let moi = Person2(firstName: "Hello", lastName: "World")
        let moi2 = Person2(firstName: "Jobs", lastName: "Steve")
        ///Encoding Person Object into Data Object
        let moiData = try! PropertyListEncoder().encode(moi)
        let moiData2 = try! PropertyListEncoder().encode(moi2)
        ///File's URL
        let moiFile = docsURL.appendingPathComponent("moi2.txt")
        ///Write Data Object to Text File.
        try! moiData.write(to: moiFile, options: .atomic)
        try! moiData2.write(to: moiFile, options: .atomic)
    }
    
    //Retrieve saved Person Object with Swift Codable from text file.
    func retrieveSavedPerson2() {
        
        let fm = FileManager.default
        let docsURL = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        ///File's URL
        let moiFile = docsURL.appendingPathComponent("moi2.txt")
        ///Init Data Objects in the text file
        let personData = try! Data(contentsOf: moiFile)
        ///Decoding Data Object to Person2 Object
        let person = try! PropertyListDecoder().decode(Person2.self, from: personData)
        print("Retrieved Person2 Object: \(person)")
    }
    
    func savePersonToFile3() {
        // ==== the NSFileCoordinator way
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            print("archiving Person using secure coding")
            let moi = Person(firstName: "Less", lastName: "Is More")
            let moiData = try NSKeyedArchiver.archivedData(withRootObject: moi, requiringSecureCoding: true)
            let moiFile = docsURL.appendingPathComponent("moi3.txt")
            
            print("writing archived Person to file with NSFileCoordinator")
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.writingIntent(with: moiFile)
            fc.coordinate(with: [intent], queue: .main) { (err) in
                do {
                    try moiData.write(to: intent.url, options: .atomic)
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func retrieveSavedPerson3() {
        // ==== the NSFileCoordinator way
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moiFile = docsURL.appendingPathComponent("moi3.txt")
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.readingIntent(with: moiFile)
            
            print("retrieving secure archived Person with NSFileCoordinator")
            fc.coordinate(with: [intent], queue: .main) { (err) in
                do {
                    let personData = try Data(contentsOf: intent.url)
                    if let person = try NSKeyedUnarchiver.unarchivedObject(ofClass: Person.self, from: personData) {
                        print(person)
                    }
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func saveDataIntoFileWrapper() {
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            print("Inits File Wrapper.")
            let d = FileWrapper(directoryWithFileWrappers: [:])

            print("Added Image Arrary into File Wrapper")
            let imNames = ["manny.jpg", "moe.jpg", "jack.jpg"]
            for imName in imNames {
                d.addRegularFile(withContents: UIImage(named: imName)!.jpegData(compressionQuality: 1)!, preferredFilename: imName)
            }
            
            print("Added property list file into File Wrapper")
            let list = try PropertyListEncoder().encode(imNames)
            d.addRegularFile(withContents: list, preferredFilename: "list")
            
            let fwURL = docsURL.appendingPathComponent("myFileWrapper")
            print("remove existed 'myFileWrapper' file")
            try? fm.removeItem(at: fwURL)
            
            do {
                print("Writes File Wrapper to a given file-system URL.")
                try d.write(to: fwURL, originalContentsURL: nil)
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
    func doRead() {
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fwURL = docsURL.appendingPathComponent("myFileWrapper")
            
            let d = try FileWrapper(url: fwURL)
            
            print("Gets 'list' file from File Wrapper through 'fileWrappers' property.")
            if let list = d.fileWrappers?["list"]?.regularFileContents {
                
                let imNames = try PropertyListDecoder().decode([String].self, from: list)
                print("Got", imNames)
                
                print("Gets Images from File Wrapper through 'fileWrappers' property")
                for imName in imNames {
                    if let imData = d.fileWrappers?[imName]?.regularFileContents {
                        print("got image data for", imName)
                        // in real life, do something with the image here
                        _ = imData
                    }
                }
            } else {
                print("No list")
            }
        } catch {
            print(error)
        }
    }
}

