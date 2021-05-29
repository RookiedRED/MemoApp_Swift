//
//  SetNewCategoryController.swift
//  Todoey
//
//  Created by 林宏諭 on 2021/5/27.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift

class SetNewCategoryController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var CategoryNameInput: UITextField!
    @IBOutlet weak var ColorRedSlider: UISlider!
    @IBOutlet weak var ColorGreenSlider: UISlider!
    @IBOutlet weak var ColorBlueSlider: UISlider!
    @IBOutlet weak var RedLabel: UILabel!
    @IBOutlet weak var GreenLabel: UILabel!
    @IBOutlet weak var BlueLabel: UILabel!
    
    
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    @IBAction func ConfirmButton(_ sender: UIButton) {
        
        if CategoryNameInput.text != "" {
            let newCategory = Category()
            newCategory.backgroundColor = (self.view.backgroundColor?.hexValue())!
            newCategory.name = CategoryNameInput.text!
            
            do{
                try realm.write{
                    realm.add(newCategory)
                }
            }catch{
                print("Error saving category \(error)")
            }
            performSegue(withIdentifier: "backToCategoryView", sender: nil)
            
//            dismiss(animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Must set Category's name", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryNameInput.delegate = self
        ColorRedSlider.value = ColorRedSlider.maximumValue/2
        ColorGreenSlider.value = ColorGreenSlider.maximumValue/2
        ColorBlueSlider.value = ColorBlueSlider.maximumValue/2
        
    }
    
    @IBAction func sliderSetColor(_ sender: Any) {
        self.view.backgroundColor = UIColor(red: CGFloat(ColorRedSlider.value/255), green: CGFloat((ColorGreenSlider.value)/255), blue: CGFloat(ColorBlueSlider.value/255), alpha: 1)
        let setContrastColor = ContrastColorOf(self.view.backgroundColor!, returnFlat: true)
        
        RedLabel.textColor = setContrastColor
        GreenLabel.textColor = setContrastColor
        BlueLabel.textColor = setContrastColor
        
        
    }
    
    //MARK: - Keyboard Manage
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}




