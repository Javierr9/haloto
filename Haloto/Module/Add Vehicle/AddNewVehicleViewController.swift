//
//  AddNewVehicleViewController.swift
//  Haloto
//
//  Created by Javier Fransiscus on 09/11/21.
//

import AsyncDisplayKit
import UIKit

class AddNewVehicleViewController: ASDKViewController<ASDisplayNode> {
    // MARK: - Components
    //TODO: Set picker default value
    //TODO: Check if all data is filled then toast
    
    
    private lazy var manufacturerFormNode: SelectFieldStack = {
        let node = SelectFieldStack(title: "Manufacturer", placeholder: "Choose your vehicle manufacturer")
        node.delegate = self
        return node
    }()

    private lazy var modelFormNode: SelectFieldStack = {
        let node = SelectFieldStack(title: "Model", placeholder: "Choose your vehicle model")
        node.delegate = self
        return node
    }()

    private lazy var odometerFormNode: FormFieldStack = {
        let node = FormFieldStack(isPicker: false, title: "Odometer", placeholder: "Current Km", keyboardType: .numberPad)
        return node
    }()

    private lazy var licensePlateFormNode: FormFieldStack = {
        let node = FormFieldStack(isPicker: false, title: "License Plate", placeholder: "License Plate", keyboardType: .default)
        return node
    }()

    private lazy var manufacturedYearFormNode: FormFieldStack = {
        // TODO: nanti pake view model set picker optionsnya bisa kan?
        let node = FormFieldStack(isPicker: true, title: "Manufactured Year", text: manufacturedYearDefaultValue, pickerOptions: ["2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007"])
        return node
    }()

    private lazy var capacityFormNode: FormFieldStack = {
        // TODO: nanti pake view model set picker optionsnya bisa kan?
        let node = FormFieldStack(isPicker: true, title: "CC", text: "\(capacityDefaultValue)", pickerOptions: ["1000", "1250", "1500", "1800", "2000"])
        return node
    }()

    private lazy var tranmissionStack: ButtonFieldStack = {
        let node = ButtonFieldStack(title: "Transmission", firstButtonText: "Matic", secondButtonText: "Manual")
        return node
    }()

    private lazy var fuelTypeStack: ButtonFieldStack = {
        let node = ButtonFieldStack(title: "Fuel Type", firstButtonText: "Diesel", secondButtonText: "Petrol")
        return node
    }()

    private var addVehicleButton: SmallButtonNode?

    private lazy var header: HeaderListPopUpNode = {
        let node = HeaderListPopUpNode(state: .newvehicle)
        node.style.width = ASDimensionMake("100%")
        return node
    }()

    // MARK: - Privates

    private var vehicle: Vehicle?
    private var stackFields: [ASDisplayNode.Type]?
    private var manufacturedYearDefaultValue = "2000"
    private var capacityDefaultValue = 0

    init(vehicle: Vehicle?, type: NewVehicleFormType) {
        
        super.init(node: ASDisplayNode())
        
        switch type {
        case .add:
            print("add")
            
            addVehicleButton = SmallButtonNode(title: "Add Vehicle", buttonState: .Yellow, function: {
                if self.checkFields(){
                    print("create model an add it to current")
                }else{
                    self.showToast(title: "Please fill in all forms")
                }
            })
        case .edit:
            
            guard let currentVehicle = vehicle else { return }

            self.vehicle = currentVehicle
            manufacturedYearDefaultValue = currentVehicle.manufacturedYear ?? ""
            capacityDefaultValue = currentVehicle.capacity ?? 0
            manufacturerFormNode.setSelected(text: "\(currentVehicle.manufacture ?? "")")
            modelFormNode.setSelected(text: "\(currentVehicle.name ?? "")")
            odometerFormNode.changeText(text: "\(currentVehicle.odometer ?? 0)")
            licensePlateFormNode.changeText(text: "\(currentVehicle.licensePlate ?? "")")
            manufacturedYearFormNode.changeText(text: "\(manufacturedYearDefaultValue)")
            capacityFormNode.changeText(text: "\(capacityDefaultValue)")

            guard let vehicleFuel = currentVehicle.fuelType else { return }
            guard let vehicleTranmission = currentVehicle.transmissionType else { return }

            if vehicleFuel.caseInsensitiveCompare("diesel") == .orderedSame {
                fuelTypeStack.setFirstButtonActive()
            } else {
                fuelTypeStack.setSecondButtonActive()
            }

            if vehicleTranmission.caseInsensitiveCompare("Automatic") == .orderedSame {
                tranmissionStack.setFirstButtonActive()
            } else {
                tranmissionStack.setSecondButtonActive()
            }

            
            addVehicleButton = SmallButtonNode(title: "Edit", buttonState: .Yellow, function: {
                //TODO: Edit action
                print("add edit action")
            })
        }

        manufacturedYearFormNode.delegate = self
        capacityFormNode.delegate = self
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white

 

        node.layoutSpecBlock = { _, _ in
            let stack = ASStackLayoutSpec(
                direction: .vertical,
                spacing: 16,
                justifyContent: .center,
                alignItems: .start,
                children: [self.manufacturerFormNode, self.modelFormNode, self.odometerFormNode, self.licensePlateFormNode, self.manufacturedYearFormNode, self.capacityFormNode, self.tranmissionStack, self.fuelTypeStack]
            )
            let addNewVehicleStack = ASStackLayoutSpec(
                direction: .vertical,
                spacing: 32,
                justifyContent: .center,
                alignItems: .center,
                children: [self.header, stack, self.addVehicleButton!]
            )

            stack.style.width = ASDimensionMake("100%")

            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: .topSafeArea, left: 16, bottom: .infinity, right: 16), child: addNewVehicleStack)
        }
        
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddNewVehicleViewController: ASEditableTextNodeDelegate {
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            editableTextNode.resignFirstResponder()
            return false
        }
        return true
    }
}

extension AddNewVehicleViewController: FormFieldStackDelegate {
    func openPickerView(sender: FormFieldStack) {
        let vc = PickerBottomSheetViewController()
        vc.configurePicker(sender: sender, options: sender.getOptions())
        let bottomSheetVC = BottomSheetViewController(wrapping: vc)
        navigationController?.present(bottomSheetVC, animated: true, completion: nil)
    }
}

extension AddNewVehicleViewController: SelectFieldStackDelegate {
    func selectFieldDidTapped(_ sender: SelectFieldStack) {
        openList(sender: sender)
    }
}

extension AddNewVehicleViewController{

    func openList(sender: SelectFieldStack){
        //MARK: Disni nanti open list depending sender.titlenya aja Manufacturer atau Model
        print("open list \(sender.title)")
    }
    
    func checkFields() -> Bool{
        //TODO: Thinking to change all the view into 1 type of class that has 1 variable or conform to a protocol so I can check whether each and every field is filled
        //TODO: next idea is just to make all of the button 1 field stack with 3 types of pilihan and therefore by doing so you can check each and every single ome to validate whether it is true or not true
        return true
    }
}
