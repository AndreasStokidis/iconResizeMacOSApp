//
//  CustomTextField.swift
//  iconresize
//
//  Created by akikos on 02/01/2019.
//  Copyright © 2019 medidia. All rights reserved.
//

import Cocoa

class CustomTextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {

        
        
        let newRect = NSRect(x: 0, y: (dirtyRect.size.height - 22) / 2, width: dirtyRect.size.width, height: 22)
        return super.draw(newRect);
        
        // Drawing code here.
    }
    
    

    
    
}
