//
//  InfoViewController.swift
//  NewFile
//
//  Created by akikos on 22/02/2018.
//  Copyright © 2018 medidia. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {

    @IBOutlet weak  var lab: NSTextView?;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        lab?.string =  NSLocalizedString("This is an essential tool for mobile and macOS developers. Resize Your Icon is an app icon maker that resizes app icon to all iOS, macOS and Android icon sizes. With Resize Your Icon, you can create icons for iOS, macOS, Android.\n\nFeatures\n- Generate icons that are required in an iOS, macOS and Android app.\n- Convert the scheme of icons easily (rounded rectangle, circle).", comment: "");
        
        
    }
    
    
    @IBAction func pressSocial(sender: NSButton) {

//        NSApplication.
        
      //  NSURL *myURL = [NSURL URLWithString:@"http://www.google.com"];
      //  [[NSWorkspace sharedWorkspace] openURL:myURL];
        
        if (sender.tag == 1){
       //     let myURL = URL(fileURLWithPath: "https://www.facebook.com/medidia/")
          //  NSWorkspace.shared.open(myURL)
        
            NSWorkspace.shared.open(URL(string: "https://www.facebook.com/medidia/")!)

        }else{
            let myURL = URL(fileURLWithPath: "https://www.instagram.com/medidia//")
            NSWorkspace.shared.open(myURL)
       //     NSWorkspace.shared.open(URL(string: "https://www.facebook.com/medidia/")!)

        }
        
        
    }
    
    
}
