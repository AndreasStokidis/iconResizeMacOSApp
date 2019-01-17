//
//  WindowsController.swift
//  iconresize
//
//  Created by akikos on 08/01/2019.
//  Copyright © 2019 medidia. All rights reserved.
//

import Cocoa

class WindowsController: NSWindowController {

    var previewWindowsController: NSViewController?
    var infoWindowsController: NSViewController?

    @IBOutlet weak  var toolbar1: NSToolbarItem?
    @IBOutlet weak  var toolbar2: NSToolbarItem?

    
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        self.previewWindowsController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier( "tab1")) as? NSViewController
        self.window?.contentViewController = self.previewWindowsController

        
        self.infoWindowsController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier( "Info")) as? NSViewController
      //  self.window?.contentViewController = self.infoWindowsController
        
        
        self.window?.title = "Resize Your Icon";
        
        
        toolbar1?.label =  (self.window?.title)!
        toolbar2?.label = NSLocalizedString("Ιnfo", comment: "");
    }
    
    @IBAction func selectMenuItem(sender: NSToolbarItem) {
        if (sender.tag == 1){
            self.window?.contentViewController = self.previewWindowsController
            
            
        }else if (sender.tag == 2){
          //  let viewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "tab2")) as! NSViewController
          //  self.window?.contentViewController = viewController
        }
        else if (sender.tag == 3){
           // let viewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "tab3")) as! NSViewController
           // self.window?.contentViewController = viewController
        }
        else if (sender.tag == 4){
          //  let viewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Info")) as! NSViewController
           // self.window?.contentViewController = viewController
            
            self.window?.contentViewController = self.infoWindowsController

            
        }
        
        
    }
    

}
