//
//  ViewController.swift
//  CoreData-Transformable
//
//  Created by Samuel Folledo on 6/29/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //MARK: Properties
    var person: Person? {
        didSet {
            guard let person = person else { return }
            nameTextField.text = person.name
            view.backgroundColor = person.favoriteColor
        }
    }
    var favoriteColor: UIColor?
    lazy var coreDataStack = CoreDataStack(modelName: "CoreData_Transformable")
    
    //MARK: Views
    var buttons: [UIButton] = []
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!

    lazy var saveEditButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.handleSavePerson))
        return barButton
    }()
    
    //MARK: App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPerson()
        setupViews()
    }
    
    //MARK: Methods
    func loadPerson() {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let results = try coreDataStack.mainContext.fetch(personFetchRequest)
            if results.count > 0 {
                // cactus found
                person = results.first
            } else {
                // not found, create cactus
                person = Person(context: coreDataStack.mainContext)
                coreDataStack.saveContext()
            }
        } catch let error as NSError {
            print("Error: \(error) description: \(error.userInfo)")
        }
    }
    
    //MARK: Helpers
    @objc func handleSavePerson() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        person!.name = name
        person!.colors = [.red, .orange, .yellow, .green, .blue, .purple]
        person!.favoriteColor = favoriteColor ?? person!.favoriteColor
        //save the managed object context
        do {
            try coreDataStack.mainContext.save()
        } catch let error as NSError {
            print("Error: \(error), description: \(error.userInfo)")
        }
    }
    
    @objc func colorButtonTapped(sender: Any) {
        let button = sender as? UIButton
        guard let color = button?.backgroundColor else { return }
        view.backgroundColor = color
        favoriteColor = color
        button?.layer.borderColor = UIColor.white.cgColor
        for coloredButton in buttons where coloredButton != button {
            coloredButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

private extension ViewController {
    func setupViews() {
        setupNavigationBar()
        setupButtons()
        nameTextField.delegate = self
    }
    
    func setupButtons() {
        buttons = [redButton, orangeButton, yellowButton,
                   greenButton, blueButton, purpleButton]
        for button in buttons { //round their corners
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.layer.borderWidth = 5
            button.layer.borderColor = UIColor.clear.cgColor
            button.addTarget(self, action: #selector(colorButtonTapped(sender:)), for: .touchUpInside)
        }
        if person!.colors.count == 0 {
            view.backgroundColor = .white
            person!.colors = [.red, .orange, .yellow, .green, .blue, .purple]
        }
        for (index, button) in buttons.enumerated() {
            button.backgroundColor = person!.colors[index]
            if let favColor = person?.favoriteColor, favColor == button.backgroundColor! {
                button.layer.borderColor = UIColor.white.cgColor
                favoriteColor = favColor
            }
        }
    }
    
    func setupNavigationBar() {
        title = "Transformable"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = saveEditButton
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
