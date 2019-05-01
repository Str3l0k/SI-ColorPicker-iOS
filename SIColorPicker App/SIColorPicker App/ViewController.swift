import UIKit
import SIColorPicker

class ViewController: UINavigationController, ColorPickerResultDelegate {
    var selectedColor: UIColor! {
        didSet {
            print("New color \(selectedColor)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorPickerStoryboard = UIStoryboard(name: "ColorPicker", bundle: Bundle(for: ColorPickerViewController.self))
        
        if let viewController = colorPickerStoryboard.instantiateInitialViewController(),
            let colorPickerViewController = viewController as? ColorPickerViewController {
            colorPickerViewController.colorDelegate = self
            
            self.pushViewController(colorPickerViewController, animated: false)
        }
    }
}

