//
//  DropDown-Swift.swift
//  DropDown-Swift
//
//  Created by Ashin Asok on 24/10/18.
//  Copyright © 2018 Ashin Asok. All rights reserved.
//

import UIKit

private var arrowPublicColor : UIColor = .black
class DropDownSwift: UITextField {

    
    var arrow   : Arrow!
    var table   : UITableView!
    var shadow  : UIView!
    
    public var selectedIndex    : Int?
    public var isRTL            : Bool = false
    public var imageName        : String = "dropdown"
    public var isSearchEnable   : Bool = false
    
    
    //MARK: IBInspectable
    @IBInspectable public var rowHeight             : CGFloat = 30
    @IBInspectable public var rowBackgroundColor    : UIColor = .white
    @IBInspectable public var arrowColor            : UIColor = .black
    @IBInspectable public var selectedRowColor      : UIColor = .gray
    @IBInspectable public var selectedTextColor     : UIColor = .white
    @IBInspectable public var hideOptionsWhenSelect : Bool = true
    @IBInspectable public var enableCheckMark       : Bool = false
    
    
    @IBInspectable public var borderColor: UIColor =  UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var listHeight: CGFloat = 150{
        didSet {
            
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    //Variables
    fileprivate  var tableheightX: CGFloat = 100
    fileprivate  var dataArray = [String]()
    public var optionArray = [String]() {
        didSet{
            self.dataArray = self.optionArray
        }
    }
    public var optionIds : [Int]?
    var searchText = String() {
        didSet{
            if searchText == "" {
                self.dataArray = self.optionArray
            }else{
                self.dataArray = optionArray.filter {
                    return $0.range(of: searchText, options: .caseInsensitive) != nil
                }
            }
            reSizeTable()
            selectedIndex = nil
            self.table.reloadData()
        }
    }
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        arrowPublicColor = arrowColor
        setupUI()
        self.delegate = self
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
        self.delegate = self
    }
    
    //MARK: Closures
    fileprivate var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in
        print("You just picked up the \(selectedText)")
        var selectedPhoneCode = selectedText
        
        print("FROM DID SELECT COMPLETION")
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerVC.getTextThatWasSelected(phoneCode: selectedText)

    }
    
    fileprivate var TableWillAppearCompletion: () -> () = { }
    fileprivate var TableDidAppearCompletion: () -> () = { }
    fileprivate var TableWillDisappearCompletion: () -> () = { }
    fileprivate var TableDidDisappearCompletion: () -> () = { }
    
    func setupUI () {
        let size = self.frame.height
        let arrowView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        let arrowContainerView = UIView(frame: arrowView.frame)
        if (!isRTL || self.semanticContentAttribute == .forceLeftToRight){
            self.rightView      = arrowView
            self.rightViewMode  = .always
            self.rightView?.addSubview(arrowContainerView)
        }else{
            self.leftView       = arrowView
            self.leftViewMode   = .always
            self.leftView?.addSubview(arrowContainerView)
        }
        
        arrow = Arrow(origin: CGPoint(x: arrowContainerView.frame.minX, y: arrowContainerView.frame.minY), size: size)
        arrowContainerView.addSubview(arrow)
        
        let image = UIImage(named: self.imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = arrow.frame
        arrow.addSubview(imageView)
        
        if isSearchEnable{
            addGesture()
        }
    }
    fileprivate func addGesture (){
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        if isSearchEnable{
            self.leftView?.addGestureRecognizer(gesture)
        }else{
            self.addGestureRecognizer(gesture)
        }
        
    }
    
    public func showList() {
        
        TableWillAppearCompletion()
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        table = UITableView(frame: CGRect(x: self.frame.minX,
                                          y: self.frame.minY,
                                          width: self.frame.width,
                                          height: self.frame.height))
        shadow = UIView(frame: CGRect(x: self.frame.minX,
                                      y: self.frame.minY,
                                      width: self.frame.width,
                                      height: self.frame.height))
        shadow.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.separatorStyle = .none
        table.layer.cornerRadius = 3
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
        var view = self.superview
        while (view?.superview?.next?.isKind(of: UIView.self))!{
            view = view?.superview
        }
        view?.insertSubview(shadow, belowSubview: self)
        view?.insertSubview(table, belowSubview: self)
        self.isSelected = true
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.maxY+5,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        
                        self.table.alpha = 1
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow()
                        self.arrow.position = .up
                        
        },
                       completion: { (finish) -> Void in
                        
        })
        
    }
    
    
    public func hideList() {
        
        TableWillDisappearCompletion()
        UIView.animate(withDuration: 1.0,
                       delay: 0.4,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.minY,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.shadow.alpha = 0
                        self.shadow.frame = self.table.frame
                        self.arrow.position = .down
        },
                       completion: { (didFinish) -> Void in
                        
                        self.shadow.removeFromSuperview()
                        self.table.removeFromSuperview()
                        self.isSelected = false
                        self.TableDidDisappearCompletion()
        })
    }
    
    @objc public func touchAction() {
        
        isSelected ?  hideList() : showList()
    }
    
    
    func reSizeTable() {
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.maxY+5,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        
                        
        },
                       completion: { (didFinish) -> Void in
                        self.shadow.layer.shadowPath = UIBezierPath(rect: self.table.bounds).cgPath
                        
        })
    }
    
    //MARK: Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }
    
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }
    
    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }
    
    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }
    
}

//MARK: UITextFieldDelegate
extension DropDownSwift : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(true)
        return false
    }
    
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        //self.selectedIndex = nil
        self.dataArray = self.optionArray
        touchAction()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isSearchEnable{
            touchAction()
        }
        return isSearchEnable
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            self.searchText = self.text! + string
        }else{
            let subText = self.text?.dropLast()
            self.searchText = String(subText!)
        }
        if !isSelected {
            showList()
        }
        return true;
    }
    
}
///MARK: UITableViewDataSource
extension DropDownSwift: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DropDownCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if indexPath.row != selectedIndex{
            cell!.backgroundColor = rowBackgroundColor
            cell?.textLabel?.textColor = self.textColor
        }else {
            cell?.backgroundColor = selectedRowColor
            cell?.textLabel?.textColor = selectedTextColor
        }
        
        cell?.textLabel?.font = self.font
        cell!.textLabel!.text = "\(dataArray[indexPath.row])"
        //cell!.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        cell!.selectionStyle = .none
        cell?.textLabel?.textAlignment = self.textAlignment
        return cell!
    }
}
//MARK: UITableViewDelegate
extension DropDownSwift: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temp = selectedIndex
        selectedIndex = (indexPath as NSIndexPath).row
        let selectedText = self.dataArray[self.selectedIndex!]
        tableView.cellForRow(at: indexPath)?.alpha = 0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        
                        if(temp != nil){
                            let index = IndexPath(row: temp!, section: 0)
                            tableView.cellForRow(at: index)
                            tableView.cellForRow(at: index)?.backgroundColor = self.rowBackgroundColor
                            tableView.cellForRow(at: index)?.textLabel?.textColor = self.textColor
                            //tableView.reloadRows(at: [index], with: .none)
                        }
                        
                        tableView.cellForRow(at: indexPath)?.alpha = 1.0
                        tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedRowColor
                        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = self.selectedTextColor
        } ,
                       completion: { (didFinish) -> Void in
                        self.text = "\(selectedText)"
                        
                        tableView.reloadData()
        })
        if hideOptionsWhenSelect {
            touchAction()
            self.endEditing(true)
        }
        if let selected = optionArray.index(where: {$0 == selectedText}) {
            if let id = optionIds?[selected] {
                print("1 before - selectedIndex is \(selectedText)")
                
//                    var registerVC = RegisterViewController()
//                    registerVC.getTextThatWasSelected(phoneCode: selectedText)
                
                
                didSelectCompletion(selectedText, selected , id )
            }else{
                print("2 before - selectedIndex is \(selectedText)")
                
//                var registerVC = RegisterViewController()
//                registerVC.getTextThatWasSelected(phoneCode: selectedText)

                
                didSelectCompletion(selectedText, selected , 0)
            }
            
        }
        
    }
}


//MARK: Arrow
enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    
    var position: Position = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break
                
            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break
                
            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break
                
            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
}

