//
//  StockListVC.swift
//  ios-base-viper
//
//  Created by Isaac on 11/13/22.
//

import UIKit

protocol HandleSelect {
    func didSelectData(data: StockListData)
}

class StockListVC: UIViewController {
    
    @IBOutlet weak var closedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var delegate: HandleSelect?
    private var listDataDefault: [StockListData] = [
        StockListData(title: "AAPL", desc: "Apple Inc.", status: "SML"),
        StockListData(title: "GOOG", desc: "Alphabet Inc. Class A", status: "SML"),
        StockListData(title: "UNVR", desc: "Unilever Indonesia Tbk.", status: "SML"),
        StockListData(title: "BBCA", desc: "Bank Central Asia Tbk.", status: "ML"),
        StockListData(title: "DRMA", desc: "Dharma Polimetal Tbk.", status: "L")
    ]
    private var listData: [StockListData] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listData = listDataDefault
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        setupTable()

        closedImageView.tapGesture(action: {
            self.backToPreviousVC()
        })
        
        searchTF.addTarget(self, action: #selector(searchDidChanges), for: .editingChanged)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            topHeight.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        topHeight.constant = 0
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StockListCell", bundle: nil), forCellReuseIdentifier: "StockListCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc private func searchDidChanges(){
        if searchTF.text == "" {
            listData = listDataDefault
        } else {
            listData = listDataDefault.filter({$0.title.lowercased().contains(searchTF.text ?? "")})
        }
        tableView.reloadData()
    }
    
    func dismissAct(){
        dismiss(animated: true, completion: nil)
    }
}

extension StockListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockListCell", for: indexPath) as? StockListCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = listData[indexPath.row].title
        cell.descLabel.text = listData[indexPath.row].desc
        cell.sLabel.textColor = listData[indexPath.row].status.contains("S") ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4549019608, alpha: 1)
        cell.mLabel.textColor = listData[indexPath.row].status.contains("M") ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4549019608, alpha: 1)
        cell.lLabel.textColor = listData[indexPath.row].status.contains("L") ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4549019608, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectData(data: listData[indexPath.row])
        dismissAct()
    }
}
