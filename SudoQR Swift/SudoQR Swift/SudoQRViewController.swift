//
//  SudoQRViewController.swift
//  SudoQR Swift
//
//  Created by Romy on 8/17/15.
//  Copyright (c) 2015 Romy. All rights reserved.
//

import UIKit
import AVFoundation

class SudoQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var innerLabel: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var scanningBarButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Action Methods
    
    @IBAction func startStopReading(sender: AnyObject) {
    }

}
