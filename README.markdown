# PatternPicker

A drop-in color picker component that also suppports gradients and repeating patterns.

<img src="https://raw.githubusercontent.com/nate-parrott/PatternPicker/master/Screenshots/Blue.png" width="200"/> <img src="https://raw.githubusercontent.com/nate-parrott/PatternPicker/master/Screenshots/LightBlue.png" width="200"/> <img src="https://raw.githubusercontent.com/nate-parrott/PatternPicker/master/Screenshots/BluePink.png" width="200"/> <img src="https://raw.githubusercontent.com/nate-parrott/PatternPicker/master/Screenshots/RedYellow.png" width="200"/> <img src="https://raw.githubusercontent.com/nate-parrott/PatternPicker/master/Screenshots/RedYellowFinal.png" width="200"/>

## Usage

PatternPicker uses `Pattern` objects to represent solid colors, gradients and repeating textures. The `PatternView` UIView subclass efficiently renders `Pattern`s.

Here's an example of a simple view controller containing a `PatternPickerView` and a `PatternView` that renders the selected pattern:

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

