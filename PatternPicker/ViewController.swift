//
//  ViewController.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        patternPicker.shouldEditModally = {
            [weak self] in
            self!.patternPicker.editModally(self!)
        }
        patternPicker.onPatternChanged = {
            [weak self]
            (pattern) in
            self!.preview.pattern = pattern
        }
        preview.pattern = patternPicker.pattern
    }
    
    @IBOutlet var patternPicker: PatternPickerView!
    @IBOutlet var preview: PatternView!


}

