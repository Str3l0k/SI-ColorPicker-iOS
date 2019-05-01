import UIKit

public class ColorPickerViewController: UIViewController {
    
    // MARK: - ib outlets
    // MARK: views
    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var colorHexTextField: UITextField!
    @IBOutlet weak var textFieldYConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // MARK: - properties
    internal var hexTextFieldCenter: CGPoint!
    public var colorDelegate: ColorPickerResultDelegate?
    
    // MARK: - preconfigure options
    var defaultColor: UIColor?
    var defaultPreview: Bool = false
    var followUpViewController: UIViewController?
    var selectedColor: UIColor {
        return colorPickerView.color
    }
    
    // MARK: - bar actions
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAction(_ sender: UIBarButtonItem) {
        if let viewController = followUpViewController {
            show(viewController, sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - color picker callback
    private func updateColor(_ color: UIColor) {
        colorHexTextField.text = "#\(color.hexString)"
        colorDelegate?.selectedColor = color
    }
    
    // MARK: - ib actions
    @IBAction func hexColorCodeChanged(_ sender: UITextField) {
        if let text = sender.text {
            if let color = parseHexCode(from: text) {
                sender.textColor = UIColor.white
                colorPickerView.color = color
            } else {
                sender.textColor = UIColor.red
            }
        }
    }
    
    @IBAction func hexColorCodeEditEnd(_ sender: UITextField) {
        if let text = sender.text {
            if let color = parseHexCode(from: text) {
                sender.textColor = UIColor.white
                colorPickerView.color = color
            } else {
                sender.textColor = UIColor.red
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            sender.transform = CGAffineTransform.identity
        }
        
        sender.resignFirstResponder()
    }
    
    @IBAction func hexColorCodeEditBegin(_ sender: UITextField) {
        sender.becomeFirstResponder()
    }
}

// MARK: - view lifecycle
extension ColorPickerViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        colorPickerView.colorUpdated = updateColor(_:)
        colorPickerView.defaultPreview = defaultPreview
        updateColor(colorPickerView.color)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let defaultColor = defaultColor {
            colorPickerView.color = defaultColor
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hexTextFieldCenter = colorHexTextField.center
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
}

// MARK: - hex-string code behaviour
extension ColorPickerViewController {
    internal func parseHexCode(from text: String) -> UIColor? {
        guard text.count == 7, text.hasPrefix("#") else {
            return nil
        }
        
        var colorText = String(text)
        colorText.remove(at: colorText.startIndex)
        
        let values = colorText.split(by: 2)
        let colorValues = values.map { (value) -> CGFloat in
            let validValue = Int(value, radix: 16) ?? 255
            return CGFloat(validValue % 256) / 255
        }
        
        let newColor = UIColor(red: colorValues[0], green: colorValues[1], blue: colorValues[2], alpha: 1)
        
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.blurView?.backgroundColor = newColor
        }
        
        return newColor
    }
}

// MARK: - keyboard behaviour
extension ColorPickerViewController {
    override func keyboardWillOpen(rect: CGRect) {
        let scale: CGFloat = 2.15
        let scaledHeight = colorHexTextField.bounds.height * scale
        
        let keyboardTop = view.bounds.height - rect.height
        let textFieldBottom = colorHexTextField.center.y + scaledHeight / 2
        
        var deltaY: CGFloat = 0.0
        
        if (textFieldBottom > keyboardTop) {
            deltaY = keyboardTop - colorHexTextField.center.y - scaledHeight / 2 - 8
        } else {
            deltaY = keyboardTop - colorHexTextField.center.y - scaledHeight / 2 - 8
        }
        
        blurView.backgroundColor = colorPickerView.color
        blurView.isHidden = false

        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
            let translateTransform = CGAffineTransform(translationX: 0, y: deltaY)
            
            self.blurView.alpha = 0.6
            self.colorHexTextField.transform = scaleTransform.concatenating(translateTransform)
        })
    }
    
    override func keyboardWillClose() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.blurView.alpha = 0
            self.colorHexTextField.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.blurView.isHidden = true
        })
    }
}
