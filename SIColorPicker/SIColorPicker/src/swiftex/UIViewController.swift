import Foundation

// MARK: - soft keyboard related
extension UIViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let dict = notification.userInfo
        let keyboardFrame = dict?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        keyboardWillOpen(rect: keyboardFrame)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardWillClose()
    }
    
    @objc func keyboardWillOpen(rect: CGRect) {
        
    }
    
    @objc func keyboardWillClose() {
        
    }
}
