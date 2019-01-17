//
//  ViewController.swift
//  iconresize
//
//  Created by akikos on 29/12/2018.
//  Copyright © 2018 medidia. All rights reserved.
//

import Cocoa

extension NSImage {
    func imagePNGRepresentation() -> NSData? {
        if let imageTiffData = self.tiffRepresentation, let imageRep = NSBitmapImageRep(data: imageTiffData) {
            // let imageProps = [NSImageCompressionFactor: 0.9] // Tiff/Jpeg
            // let imageProps = [NSImageInterlaced: NSNumber(value: true)] // PNG
            let imageData = imageRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) as NSData?
            return imageData
        }
        return nil
    }
    
    
    func roundCorners(width: CGFloat = 1024, height: CGFloat = 1024, scheme: Int = 0) -> NSImage {
       // let xRad = width / 4
       // let yRad = height / 4
        
        if (scheme == 2){
            return self;
        }
        
        let existing = self
        let esize = existing.size
        
        
        let newSize = NSMakeSize(esize.width, esize.height)
         var xRad = newSize.width / 6
         var yRad = newSize.height / 6
        
        if (scheme == 1){
            xRad = newSize.width / 2
            yRad = newSize.height / 2
        }
        
        
        let composedImage = NSImage(size: newSize)
        
        composedImage.lockFocus()
        let ctx = NSGraphicsContext.current
        ctx?.imageInterpolation = NSImageInterpolation.high
        
//        let imageFrame = NSRect(x: 0, y: 0, width: width, height: height)
        let imageFrame = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        let clipPath = NSBezierPath(roundedRect: imageFrame, xRadius: xRad, yRadius: yRad)
        clipPath.windingRule = NSBezierPath.WindingRule.evenOdd
        clipPath.addClip()
        
        let rect = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        self.draw(at: NSZeroPoint, from: rect, operation: .sourceOver, fraction: 1)
        composedImage.unlockFocus()
        
        
        
        return composedImage
    }
    
    /*
    // then
    roundCorners(image)
    roundCorners(image, width: 512, height: 512)
    
    */
    
    
    
    
}






extension NSImageView {
    override open func mouseDown(with event: NSEvent) {
        // your code here
    }
    
   
    override open func willChangeValue(forKey key: String) {
        
    }
    
}


// Mapping to Integer
enum tabName: Int {
    case  SelectiOS = 0
    case  SelectMacOSX = 1
    case  SelectAndroid = 2
}

enum scheme: Int {
    case rectangle = 0
    case  circle = 1
    case  nothing = 2

}

enum formatfile:  Int {
    case jpg = 0
    case  png = 1
}

class ViewController: NSViewController {
    @IBOutlet var imgPicker: NSImageView?
    @IBOutlet var butExport: NSButton?
    @IBOutlet var labelString: NSTextField?
    @IBOutlet var seg: NSSegmentedControl?

    @IBOutlet var seg2: NSSegmentedControl?

    
    @IBOutlet var labelPlatform: NSTextField?
    @IBOutlet var labelScheme: NSTextField?

    @IBOutlet var butRemove: NSButton?

    
    
    func resize(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
    newImage.lockFocus()

        
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from:  NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction:  CGFloat(1));
        
        newImage.unlockFocus()
    newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    
    func exportImg(img: NSImage?, url: URL, strName: String, type: Int  = 0, formatPar: Int = 0){
        


        
        if let imgRep = img!.representations[0] as? NSBitmapImageRep
        {
            
            
            if var data = imgRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])
            {
                
                if (formatPar == 1){
                    data = imgRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])!
                }
                
                let isSecuredURL = url.startAccessingSecurityScopedResource();

                let coordinator = NSFileCoordinator()
                var error: NSError? = nil
                coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
                    do {
                        // do something
                        var fp = (url.path) + "/" + strName + ".jpg";

                        if (formatPar == 1){
                            fp = (url.path) + "/" + strName + ".png";
                        }
                        
                        let up = URL(fileURLWithPath: fp)
                        
                        print ("ok");
                        try!  data.write(to: up);
                        
                        
                    } catch (let error ) {
                        // something went wrong
                        print(error.localizedDescription);
                    }
                }
                
             
                 if (isSecuredURL) {
                     url.stopAccessingSecurityScopedResource()
                 }
                
            }
        }
    }
    
    
    
    @IBAction func export(sender: AnyObject) {

        let savePanel = NSOpenPanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.canChooseDirectories = true;
        savePanel.canChooseFiles = false;
        savePanel.allowsMultipleSelection = false;
    
    //    savePanel.nameFieldStringValue = "result.png"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result) in
            
            print(result);
            
            
            if result == NSApplication.ModalResponse.OK {
                
             

        
                
                let url = savePanel.url!;
                
                let img = self.imgPicker?.image

               // self.exportImg(img:  self.resize(image: img!.roundCorners(), w: 512*1, h: 512) , url: url, strName: "icon-1024test", type: 1);
               // self.exportImg(img:  self.resize(image: img!.roundCorners(), w: 512*1, h: 512) , url: url, strName: "icon-1024test2", type: 0);
              //  self.exportImg(img:  self.resize(image: img!.roundCorners(circle: true), w: 512*1, h: 512) , url: url, strName: "icon-1024test2", type: 1);

        
                var firstObjectname = "";
            
                if (self.seg?.selectedSegment == tabName.SelectiOS.rawValue){
                
                    firstObjectname = "icon-20@1x.jpg"
                    self.exportImg(img:  self.resize(image: img!, w: 20*1, h: 20*1) , url: url, strName: "icon-20@1x");
                    self.exportImg(img:  self.resize(image: img!, w: 20*2, h: 20*2) , url: url, strName: "icon-20@2x");
                    self.exportImg(img:  self.resize(image: img!, w: 20*3, h: 20*3) , url: url, strName: "icon-20@3x");
                    self.exportImg(img:  self.resize(image: img!, w: 29*1, h: 29*1) , url: url, strName: "icon-29@1x");
                    self.exportImg(img:  self.resize(image: img!, w: 29*2, h: 29*2) , url: url, strName: "icon-29@2x");
                    self.exportImg(img:  self.resize(image: img!, w: 29*3, h: 29*3) , url: url, strName: "icon-29@3x");
                    self.exportImg(img:  self.resize(image: img!, w: 40*1, h: 40*1) , url: url, strName: "icon-40@1x");
                    self.exportImg(img:  self.resize(image: img!, w: 40*2, h: 40*2) , url: url, strName: "icon-40@2x");
                    self.exportImg(img:  self.resize(image: img!, w: 40*3, h: 40*3) , url: url, strName: "icon-40@3x");
                    self.exportImg(img:  self.resize(image: img!, w: 76*1, h: 76*1) , url: url, strName: "icon-76@1x");
                    self.exportImg(img:  self.resize(image: img!, w: 76*2, h: 76*2) , url: url, strName: "icon-76@2x");
                    
                    self.exportImg(img:  self.resize(image: img!, w: 60*1, h: 60*1) , url: url, strName: "icon-60@1x");
                    self.exportImg(img:  self.resize(image: img!, w: 60*2, h: 60*2) , url: url, strName: "icon-60@2x");
                    self.exportImg(img:  self.resize(image: img!, w: 60*3, h: 60*3) , url: url, strName: "icon-60@3x");

                    
                    self.exportImg(img:  self.resize(image: img!, w: Int(83.5*2), h: Int(83.5*2)) , url: url, strName: "icon-83.5@2x");
                    self.exportImg(img:  self.resize(image: img!, w: Int(1024*1), h: Int(1024*1)) , url: url, strName: "icon-1024@1x");
                }
                
                if (self.seg?.selectedSegment == tabName.SelectMacOSX.rawValue){
                    var isScheme: Int = 0;
                    var format: Int = 0;
                    if (self.seg2?.selectedSegment == scheme.circle.rawValue){
                        isScheme = scheme.circle.rawValue;
                    }else if (self.seg2?.selectedSegment == scheme.rectangle.rawValue){
                        isScheme = scheme.rectangle.rawValue;
                    }else if (self.seg2?.selectedSegment == scheme.nothing.rawValue){
                        isScheme = scheme.nothing.rawValue;
                    }
                    format = formatfile.png.rawValue
                    firstObjectname = "icon-16@1x.png"
                 
                    
                    
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 16*1, h: 16*1) , url: url, strName: "icon-16@1x", formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 16*2, h: 16*2) , url: url, strName: "icon-16@2x", formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 32*1, h: 16*2) , url: url, strName: "icon-32@1x",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 32*2, h: 32*2) , url: url, strName: "icon-32@2x",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 128*1, h: 128*1) , url: url, strName: "icon-128@1x",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 128*2, h: 128*2) , url: url, strName: "icon-128@2x",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme  ), w: 256*1, h: 256*1) , url: url, strName: "icon-256@1x",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme ), w: 256*2, h: 256*2) , url: url, strName: "icon-256@2x", formatPar: format );
                
        
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 512*1, h: 512*1) , url: url, strName: "icon-512@1x", formatPar: format );
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 512*2, h: 512*2) , url: url, strName: "icon-512@2x", formatPar: format );

         

                }
                
                if (self.seg?.selectedSegment == tabName.SelectAndroid.rawValue){
                    firstObjectname = "mipmap-hdpi.png"


                    var isScheme: Int = 0;
                    var format: Int = 0;
                    if (self.seg2?.selectedSegment == scheme.circle.rawValue){
                        isScheme = scheme.circle.rawValue;
                        format = formatfile.png.rawValue
                    }else if (self.seg2?.selectedSegment == scheme.rectangle.rawValue){
                        isScheme = scheme.rectangle.rawValue;
                        format = formatfile.png.rawValue
                    }else if (self.seg2?.selectedSegment == scheme.nothing.rawValue){
                        isScheme = scheme.nothing.rawValue;
                        format = formatfile.png.rawValue
                    }
                    
                    
                    if (format == formatfile.png.rawValue){
                        firstObjectname = "mipmap-hdpi.png"
                    }else{
                        firstObjectname = "mipmap-hdpi.jpg"
                    }
                    
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 72*1, h: 72*1) , url: url, strName: "mipmap-hdpi",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 48*1, h: 48) , url: url, strName: "mipmap-mdpi",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 96*1, h: 96) , url: url, strName: "mipmap-xhdpi",  formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 144*1, h: 144) , url: url, strName: "mipmap-xxhdpi", formatPar: format);
                    self.exportImg(img:  self.resize(image: img!.roundCorners(scheme: isScheme), w: 192*1, h: 192) , url: url, strName: "mipmap-xxxhdpi",  formatPar: format);
                    
                
                }

                
                
                
                
                
                   let p = savePanel.directoryURL?.path
              let str =     "\(p!)/\(firstObjectname)"
                
                NSWorkspace.shared.activateFileViewerSelecting([ URL(fileURLWithPath: str)]);
                //[[NSWorkspace, sharedWorkspace] activateFileViewerSelectingURLs:[url]];

                
                /*
                
                let fp = (url.path) + "/ddd.png";
                let fp2 = (url.path) + "/teddd2.png";

                
                print(fp);
                print(fp2);

                
                let up = URL(fileURLWithPath: fp)
                let up2 = URL(fileURLWithPath: fp2)

                
           //     let img =  self.resize(image: (self.imgPicker?.image)!, w: 300, h: 300);
                let img =  self.imgPicker?.image;
                let img2 =  self.resize(image: (self.imgPicker?.image)!, w: 23, h: 23);
                    

                
                if let imgRep = img!.representations[0] as? NSBitmapImageRep
                {
                    if let data = imgRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])
                    {
               
                        let isSecuredURL = url.startAccessingSecurityScopedResource();
                        
                print(isSecuredURL);
                        
                let coordinator = NSFileCoordinator()
                var error: NSError? = nil
                coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
                    do {
                        // do something
                        
                        print ("ok");
                        try!  data.write(to: up);
                        try!  data.write(to: up2);

                        
                    } catch (_) {
                        // something went wrong
                    }
                }
               // if (isSecuredURL) {
              //      url.stopAccessingSecurityScopedResource()
               // }
                
            }}
            }}
                
 
                
                let img =  self.resize(image: (self.imgPicker?.image)!, w: 300, h: 300);
                
                
            

                
                print(img);

                

            
                
                if let imgRep = img.representations[0] as? NSBitmapImageRep
                {
                    if let data = imgRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
                    {
                       //data.writeToFile(p, atomically: false)
                    

                        do{
                            
                        
                            

                         let succeeded: Bool = up.startAccessingSecurityScopedResource()

                            print(succeeded);
                            
                            if (succeeded){
                                try  data.write(to: up);

                                up.stopAccessingSecurityScopedResource();
                            }
                            
                         //   up.bookmarkData(options: <#T##URL.BookmarkCreationOptions#>, includingResourceValuesForKeys: <#T##Set<URLResourceKey>?#>, relativeTo: <#T##URL?#>)
                      // try  data.write(to: up);
                       // try  data.write(to: up2);
                        } catch {
                          print("File not saved:\n\((error as NSError).description)")

                        }
                    

                        
            
                    }
                }
 */
            }
 
 
            
            
            
            
 }
        
 
 
 
    }
    
    
    @IBAction func changeTab(sender: NSSegmentedControl){
        let user = UserDefaults.standard;
        let num = sender.selectedSegment;
        user.setValue(num, forKey: "seg");
        user.synchronize();
        
        if (num == 2 ||  num == 1 ){
            self.seg2?.isHidden = false;
            self.labelScheme?.isHidden = false;

        }else{
            self.seg2?.isHidden = true;
            self.labelScheme?.isHidden = true;

        }
        
    }
    
    
    @IBAction func changeTab2(sender: NSSegmentedControl){
        let user = UserDefaults.standard;
        let num = sender.selectedSegment;
        user.setValue(num, forKey: "seg2");
        user.synchronize();
    }
    
    
    
    @IBAction func resize(sender: Any){
        
    }
    
    
    func initItems(){
        self.butExport?.stringValue = NSLocalizedString("Export", comment: "");
        let user = UserDefaults.standard;
        let num = user.value(forKey: "seg") as? Int
        if (num != nil){
            self.seg?.selectedSegment = num!;
        }
        let num2 = user.value(forKey: "seg2") as? Int
        if (num2 != nil){
            self.seg2?.selectedSegment = num2!;
        }
        self.changeTab(sender: self.seg!)
        self.changeTab2(sender: self.seg2!)
        self.exporte(sender: self.butExport!);
        self.seg?.setLabel( NSLocalizedString("iOS", comment:"" ), forSegment: 0)
        self.seg?.setLabel( NSLocalizedString("MACOS", comment:"" ), forSegment:1)
        self.seg?.setLabel( NSLocalizedString("Android", comment:"" ), forSegment: 2)
        self.seg2?.setLabel( NSLocalizedString("rounded rectagle", comment:"" ), forSegment: 0)
        self.seg2?.setLabel( NSLocalizedString("circle", comment:"" ), forSegment:1)
        self.seg2?.setLabel( NSLocalizedString("none", comment:"" ), forSegment: 2)
  //
        self.labelPlatform?.stringValue = NSLocalizedString("Platform:", comment: "")
        self.labelScheme?.stringValue = NSLocalizedString("Scheme:", comment: "")


    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initItems();
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }

    @IBAction func exporte(sender: AnyObject) {
    if (self.imgPicker?.image == nil){
        self.butExport?.isHidden  = true;
        self.imgPicker?.image = NSImage(named: "upload")
        self.labelString?.stringValue = NSLocalizedString("Add an image, dragged it\nat rectangle above", comment: "")
        self.seg?.isHidden = true;
        self.seg2?.isHidden = true;
        self.labelPlatform?.isHidden = true;
        self.labelScheme?.isHidden = true;
        self.butRemove?.isHidden = true;
        
    }else{
        self.butExport?.isHidden  = false;
        self.labelString?.stringValue = NSLocalizedString("Press the button to select the exported folder\nand export the images", comment: "")
      //  self.imgPicker?.image  =  self.resize(image: (self.imgPicker?.image)!.roundCorners(), w: 1024, h: 1024);
        self.imgPicker?.image  =  self.resize(image: (self.imgPicker?.image)!, w: 1024, h: 1024);
        self.butExport?.title =  NSLocalizedString("Export",comment: "");
        self.seg?.isHidden = false;
        self.labelPlatform?.isHidden = false;
        self.butRemove?.isHidden = false;

        self.changeTab(sender: self.seg!)
        self.seg?.becomeFirstResponder()
        }
    }
    
    
    @IBAction func removePict(sender: NSButton){
        self.imgPicker?.image = nil;
        self.exporte(sender: self.imgPicker!);
    }
    
    
    
}

