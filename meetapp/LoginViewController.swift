//
//  LoginViewController.swift
//  meetapp
//
//  Created by Nurlan on 30/04/2016.
//  Copyright © 2016 Nurlan. All rights reserved.
//

import UIKit

class LoginViewControllel: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var imageAvatar: UIImageView!

    let imagePicker = UIImagePickerController()

    @IBAction func loadAvatar(sender: UIButton) {

        imagePicker.editing = false
        imagePicker.sourceType = .SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nameTextField.autocorrectionType = .No
        nameTextField.autocapitalizationType = .Words
        nameTextField.keyboardType = .ASCIICapable
        nameTextField.returnKeyType = .Done
        self.nameTextField.becomeFirstResponder()
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageAvatar.contentMode = .ScaleAspectFit
            imageAvatar.image = pickedImage
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

}