//
//  ColorPickerViewController.swift
//  Cosprops App
//
//  Created by Sebastian on 09.10.18.
//  Copyright © 2018 Sebastian Barz. All rights reserved.
//

import UIKit

public class ColorPickerViewController: UIViewController {
    
    // MARK: - ib outlets
    // MARK: views
    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var colorHexTextField: UITextField!
    @IBOutlet weak var textFieldYConstraint: NSLayoutConstraint!
    
    internal var hexTextFieldCenter: CGPoint!
    
    // MARK: - preconfigure options
    var defaultColor: UIColor?
    var defaultPreview: Bool = false
    var followUpViewController: UIViewController?
    var selectedColor: UIColor {
        return colorPickerView.color
    }
    
    // MARK: - view
    override public func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        colorPickerView.colorUpdated = updateColor(_:)
        colorPickerView.defaultPreview = defaultPreview
        updateColor(colorPickerView.color)
//        navigationController?.navigationBar.configureTitleFont()
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
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if var resultDelegate = segue.destination as? ColorPickerResultDelegate {
            resultDelegate.selectedColor = selectedColor
        }
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
    
    @IBAction func hexColorCodeEnd(_ sender: UITextField) {
        if let text = sender.text {
            if let color = parseHexCode(from: text) {
                sender.textColor = UIColor.white
                colorPickerView.color = color
            } else {
                sender.textColor = UIColor.red
            }
        }
        
        sender.resignFirstResponder()
    }
}

// MARK: - hex code behaviour
extension ColorPickerViewController {
    internal func parseHexCode(from text: String) -> UIColor? {
        guard text.count == 7, text.hasPrefix("#") else {
            return nil
        }
        
        var colorText = String(text)
        colorText.remove(at: colorText.startIndex)
        
        let values = colorText.split(by: 2)
        let colorValues = values.map { (value) -> CGFloat in
            return CGFloat(Int(value, radix: 16)! % 256) / 255
        }
        
        return UIColor(red: colorValues[0], green: colorValues[1], blue: colorValues[2], alpha: 1)
    }
}

// MARK: - keyboard behaviour
extension ColorPickerViewController {
    override func keyboardWillOpen(rect: CGRect) {
        let keyboardTop = view.bounds.height - rect.height
        let scale: CGFloat = 1.85
        let scaledHeight = colorHexTextField.bounds.height * scale
        let newY = keyboardTop - colorHexTextField.center.y - scaledHeight / 2 - 8

        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
            let translateTransform = CGAffineTransform(translationX: 0, y: newY)
            
            self.colorHexTextField.transform = scaleTransform.concatenating(translateTransform)
        }, completion: { _ in
            self.textFieldYConstraint.constant = self.colorHexTextField.center.y - self.view.bounds.centerY
        })
    }
    
    override func keyboardWillClose() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.colorHexTextField.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.textFieldYConstraint.constant = 32
        })
    }
}
