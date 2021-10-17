//
//  MemesEditorVC.swift
//  MemeMe2
//
//  Created by Imane BOUAMAMA on 2021/10/17.
//

import UIKit

class MemesEditorVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet var topTextField : UITextField!
  @IBOutlet var bottomTextField : UITextField!
  @IBOutlet var currentImage : UIImageView!
  @IBOutlet var cameraButton: UIButton!
  
  private var memedeImage : Meme!
  
  let memeTextAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSAttributedString.Key.strokeWidth:  -10
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear( animated )
    subscribeToKeyboardNotification()
    subscribeToKeyboardHidingNotification()
    self.setUpTextField( textField: topTextField, text: "Top" )
    self.setUpTextField( textField: bottomTextField, text: "Bottom" )
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable( .camera )
    currentImage.contentMode = .scaleAspectFit
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear( animated )
      unsubscribeFromKeyBoardNotification()
      unsubscribeFromKeyBoardHidingNotification()
  }

  func setUpTextField( textField: UITextField, text: String ) {
      textField.textAlignment = .center
      textField.delegate = self
      textField.text = text
      textField.defaultTextAttributes = memeTextAttributes
  }
  
  func pickAnImageFrom ( sourceType : UIImagePickerController.SourceType ) {
      let pickerController = UIImagePickerController()
      pickerController.delegate = self
      pickerController.sourceType = sourceType
      self.present( pickerController, animated: true, completion: nil )
  }
  
  @IBOutlet var albumButton: UIButton!
  @IBAction func PickAnImage( _ sender: UIButton ) {
      pickAnImageFrom( sourceType: .photoLibrary )
  }
  
  @IBAction func PickACameraImage( _ sender: UIButton ) {
      pickAnImageFrom( sourceType: .camera )
  }
  
  @IBAction func shareButtonClicked( _ sender: UIButton ) {
    memedeImage = Meme(top: topTextField.text!, bottom: bottomTextField.text!, originalImage: currentImage, memedImage: self.genenratedMemedImage()  )
      let shareImageController = UIActivityViewController( activityItems: [memedeImage], applicationActivities: nil )
      shareImageController.completionWithItemsHandler = {
          ( activity, completed, items, error ) in
          if completed{
              self.save()

          }
      }
      self.present( shareImageController, animated: true, completion: nil )
  }
  
  func save () {
    let meme = Meme( top: topTextField.text!, bottom: bottomTextField.text!, originalImage: currentImage, memedImage: genenratedMemedImage() )
      ( UIApplication.shared.delegate as! AppDelegate).memes.append( meme )
  }
  
  
  func genenratedMemedImage() -> UIImage {
      UIGraphicsBeginImageContext( currentImage.frame.size )
      view.drawHierarchy( in: view.frame, afterScreenUpdates: true )
      let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      return memedImage
  }
  
  //This function takes a screenshot of the current displayed view. It will be called to save the image with the user typed bottom and top memes
//  func takeScreenshotOfTheView() -> UIImage {
//      UIGraphicsBeginImageContextWithOptions( UIScreen.main.bounds.size, true, 0.0 )
//      view.drawHierarchy( in: view.bounds, afterScreenUpdates: true )
//      var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//      image = cropImage( image: image )
//      UIGraphicsEndImageContext()
//      return image
//  }
//
//  func cropImage( image: UIImage ) -> UIImage {
//    let refWidth = CGFloat( ( image.cgImage!.width ) )
//    let refHeight = CGFloat( ( image.cgImage!.height ) )
//    let refSize = refWidth > refHeight ? refWidth : refHeight
//    let cropSize = 2 * refSize / 3
//    let x = ( refWidth - cropSize ) / 2.0
//    let refX = refWidth > refHeight ? 500 : 0
//    let refY = refWidth > refHeight ? 20 : -200
//    let cropRect = CGRect( x: x - CGFloat(refX),
//                           y: self.view.center.y + CGFloat(refY),
//                           width: refWidth,
//                           height: refHeight - 350 )
//    let imageRef = image.cgImage?.cropping( to: cropRect )
//    return UIImage( cgImage: imageRef! )
//  }
  
  func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                  currentImage.image = image
          
              }
      
      dismiss( animated: true, completion: nil )
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
  }
  
  func getKeyboardHeight( _ notification: Notification ) -> CGFloat {
      let userInfo = notification.userInfo
      let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
      return keyboardSize.cgRectValue.height
  }
  
  @objc func keyboardWillShow( _ notification: Notification ){
      if bottomTextField.isFirstResponder {
          self.view.frame.origin.y = -getKeyboardHeight( notification )
      }
      
  }
  
  @objc func keyboardWillHide( _ notification: Notification ){
      if bottomTextField.isFirstResponder {
          self.view.frame.origin.y = 0
      }
  }
  
  func subscribeToKeyboardNotification(){
      NotificationCenter.default.addObserver( self,
                                              selector: #selector( keyboardWillShow ),
                                              name: UIResponder.keyboardWillShowNotification,
                                              object: nil )
  }
  
  func unsubscribeFromKeyBoardNotification() {
      NotificationCenter.default.removeObserver( self,
                                                 name: UIResponder.keyboardWillShowNotification,
                                                 object: nil )
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField ) {
      textField.text = ""
          
      textField.textAlignment = .center
  }
  
  
  func subscribeToKeyboardHidingNotification() {
      NotificationCenter.default.addObserver( self,
                                              selector: #selector( keyboardWillHide ),
                                              name: UIResponder.keyboardWillHideNotification,
                                              object: nil )
  }
  
  func unsubscribeFromKeyBoardHidingNotification() {
      NotificationCenter.default.removeObserver( self,
                                                 name: UIResponder.keyboardWillHideNotification,
                                                 object: nil )
  }
  
  @IBAction func cancel () {
      if ( self.currentImage.animationDuration != nil ) {
          self.currentImage.image = nil
      }
      self.topTextField.text = "TOP"
      self.bottomTextField.text = "BOTTOM"
  }

  func generateMemedImage() -> UIImage {
    UIGraphicsBeginImageContext( currentImage.frame.size )
    view.drawHierarchy( in: view.frame, afterScreenUpdates: true )
    let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return memedImage
  }
}
