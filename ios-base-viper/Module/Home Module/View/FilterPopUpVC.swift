//
//  FilterPopUpVC.swift
//  ios-base-viper
//
//  Created by Isaac on 11/7/22.
//

import UIKit
import STPopup

protocol HandleFilter {
    func selectedFilter(data: [String])
}

class FilterPopUpVC: BaseVC {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttonView: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var popUpVC: STPopupController?
    var delegate: HandleFilter?
    var selectedData: [StockListData] = [
        StockListData(title: "Add Stock", desc: "default", status: "")
    ]
    var isMaxSelected: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        setupButton()
        
        topView.tapGesture(action: {
            self.dismissAct()
        })
    }
    
    private func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "FilterCell")
    }
    
    func dismissAct(){
        dismiss(animated: true, completion: nil)
    }
    
    private func setupButton() {
        if selectedData.count > 1 {
            buttonView.backgroundColor = #colorLiteral(red: 0.9750550389, green: 0.5568596125, blue: 0.1120470837, alpha: 1)
            buttonView.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else {
            buttonView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2117647059, blue: 0.2509803922, alpha: 1)
            buttonView.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }

    @IBAction func applyButtonAct(_ sender: Any) {
        if selectedData.count > 1 {
            dismissAct()
            var newArr: [String] = []
            selectedData.forEach{ (x) in
                if x.title != "Add Stock" {
                    newArr.append(x.title)
                }
            }
            delegate?.selectedFilter(data: newArr)
        }
    }
}

extension FilterPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: ((collectionView.frame.width / 3)), height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        
        if selectedData[indexPath.row].title == "Add Stock" {
            cell.viewWrapper.setupBorder(color: #colorLiteral(red: 0.9728146195, green: 0.578219831, blue: 0.1544066966, alpha: 1))
            cell.viewWrapper.backgroundColor = .clear
            cell.signLabel.text = "+"
            cell.signLabel.textColor = #colorLiteral(red: 0.6893270612, green: 0.4308842421, blue: 0.1638008356, alpha: 1)
            cell.titleLabel.textColor = #colorLiteral(red: 0.6893270612, green: 0.4308842421, blue: 0.1638008356, alpha: 1)
        } else {
            cell.viewWrapper.setupBorder()
            cell.viewWrapper.backgroundColor = #colorLiteral(red: 0.1794581115, green: 0.2278311253, blue: 0.2750311196, alpha: 1)
            cell.signLabel.text = "X"
            cell.signLabel.textColor = #colorLiteral(red: 0.8384261727, green: 0.8432095647, blue: 0.8475252986, alpha: 1)
            cell.titleLabel.textColor = #colorLiteral(red: 0.8384261727, green: 0.8432095647, blue: 0.8475252986, alpha: 1)
        }
        
        cell.titleLabel.text = selectedData[indexPath.row].title
        
        cell.viewWrapper.tapGesture(action: { [self] in
            if selectedData[indexPath.row].title == "Add Stock" && isMaxSelected == false {
                let viewController = StockListVC(nibName: "StockListVC", bundle: nil)
                viewController.delegate = self
                self.popUpVC = STPopupController(rootViewController: viewController)
                self.popUpVC?.style = .bottomSheet
                self.popUpVC?.containerView.backgroundColor = UIColor.clear
                self.popUpVC?.navigationBarHidden = true
                DispatchQueue.main.async {
                    self.popUpVC?.present(in: self)
                }
            } else {
                if selectedData[indexPath.row].title != "Add Stock" {
                    var newArr: [String] = []
                    selectedData.forEach{ (x) in
                        newArr.append(x.title)
                    }
                    if let index = newArr.firstIndex(of: selectedData[indexPath.row].title) {
                        selectedData.remove(at: index)
                    }
                    
                    if selectedData.count < 6 {
                        isMaxSelected = false
                    } else {
                        isMaxSelected = true
                    }
                    collectionView.reloadData()
                }
            }
        })
        
        return cell
    }
}

extension FilterPopUpVC: HandleSelect {
    func didSelectData(data: StockListData) {
        if selectedData.filter({$0.title == data.title}).count == 0 {
            selectedData.append(data)
            setupButton()
            if selectedData.count == 6 {
                isMaxSelected = true
            }
            
            collectionView.reloadData()
        }
    }
}
