//
//  HomeVC.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import UIKit
import STPopup

protocol HomeView: BaseView {
    var presenter: HomePresenter? { get set }
    
    func update(with data: [ResultModel])
    func update(with error: String)
}

class HomeVC: BaseVC, HomeView {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stockFilterLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    
    var presenter: HomePresenter?
    var popUpVC: STPopupController?
    
    var titleValue: [String] = ["STOCK", "PRICE", "CHG", "VOL", "ACT", "TIME"]
    var symbolListAll: [String] = ["AAPL", "GOOG", "UNVR", "BBCA", "DRMA"]
    var filterList: [String] = []
    var symbolList: [String] = ["AAPL", "GOOG", "UNVR", "BBCA", "DRMA"]
    var dataList: ShowModel?
    var isFirstData: Bool = true
    var symbol: String = "aapl"
    var interval: String = "1m"
    var range: String = "1d"
    var count: Int = 0
    var isFilterActive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupTable()
        
        stockFilterLabel.tapGesture(action: {
            self.showFilterPopUp()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setupNavBarSquareArrow(title: "RUNNING TRADE")
    }
    
    func update(with data: [ResultModel]) {
        let value = Double.random(in: 0.0 ..< 1000.0)
        let price = Double(round(10 * value) / 10)
        let chgValue = Double.random(in: 0.0 ..< 20.0)
        let chg = Double(round(100 * chgValue) / 100)
        
        if isFirstData {
            var timeStampData: [ShowModelDetailWithPrice] = []
            var volumeData: [ShowModelDetailInt] = []
            var priceData: [ShowModelDetailDouble] = []
            
            data.forEach{ (x) in
                x.timestamp?.forEach{ (y) in
                    
                    let newModel = ShowModelDetailWithPrice(chg: chg, price: price, type: x.meta?.symbol ?? "", value: Date())
                    timeStampData.append(newModel)
                }
                
                x.indicators?.quote?[0].volume.forEach{ (y) in
                    let newModel = ShowModelDetailInt(type: x.meta?.symbol ?? "", value: y ?? 0)
                    volumeData.append(newModel)
                }
                
                x.indicators?.quote?[0].close.forEach{ (y) in
                    let newModel = ShowModelDetailDouble(type: x.meta?.symbol ?? "", value: y ?? 0)
                    priceData.append(newModel)
                }
            }
            
            dataList = ShowModel(timeStamp: timeStampData, volume: volumeData, price: priceData)
        } else {
            data.forEach{ (x) in
                x.timestamp?.forEach{ (y) in
                    if y == x.timestamp?[0] {
                        let newModel = ShowModelDetailWithPrice(chg: chg, price: price, type: x.meta?.symbol ?? "", value: Date())
                        dataList?.timeStamp?.append(newModel)
                    }
                    
                }
                
                x.indicators?.quote?[0].volume.forEach{ (y) in
                    if y == x.indicators?.quote?[0].volume[0] {
                        let newModel = ShowModelDetailInt(type: x.meta?.symbol ?? "", value: y ?? 0)
                        dataList?.volume?.append(newModel)
                    }
                }
            }
        }
        
        setupPresenter()
    }
    
    func update(with error: String) {
        if isFirstData {
            var timeStampData: [ShowModelDetailWithPrice] = []
            var volumeData: [ShowModelDetailInt] = []
            var priceData: [ShowModelDetailDouble] = []
            
            let timeStampDataModel = ShowModelDetailWithPrice(chg: 0, price: 0, type: "-", value: Date())
            timeStampData.append(timeStampDataModel)
                
            let volumeDataModel = ShowModelDetailInt(type: "-", value: 0)
            volumeData.append(volumeDataModel)
        
            let newModel = ShowModelDetailDouble(type:"-", value: 0)
            priceData.append(newModel)
            
            dataList = ShowModel(timeStamp: timeStampData, volume: volumeData, price: priceData)
        } else {
            let timeStampModel = ShowModelDetailWithPrice(chg: 0, price: 0, type:"-", value: Date())
            dataList?.timeStamp?.append(timeStampModel)
            
            let volumeModel = ShowModelDetailInt(type: "-", value: 0)
            dataList?.volume?.append(volumeModel)
        }
        
        setupPresenter()
    }
    
    private func setupPresenter() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                isFirstData = false
                let bodyReq = HomeBodyRequest(interval: interval, range: range)
                presenter?.interactor?.getHomeList(body: bodyReq, symbol: symbol)
                
                let idx = Int.random(in: 0 ..< symbolList.count)
                if count == 3 {
                    
                    symbol = symbolList[idx]
                }
                count = Int.random(in: 0 ..< 4)
            }
        }
    }
    
    func showFilterPopUp(){
        let viewController = FilterPopUpVC(nibName: "FilterPopUpVC", bundle: nil)
        viewController.delegate = self
        
        var newFilter: [StockListData] = [StockListData(title: "Add Stock", desc: "default", status: "")]
        filterList.forEach{ (x) in
            newFilter.append(StockListData(title: x, desc: "", status: ""))
        }
        viewController.selectedData = newFilter
        
        self.popUpVC = STPopupController(rootViewController: viewController)
        self.popUpVC?.style = .bottomSheet
        self.popUpVC?.containerView.backgroundColor = UIColor.clear
        self.popUpVC?.navigationBarHidden = true
        DispatchQueue.main.async {
            self.popUpVC?.present(in: self)
        }
    }
    
    private func setupCollection() {
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        titleCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        titleCollectionView.isScrollEnabled = false
        titleCollectionView.reloadData()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RunningTradeRowCell", bundle: nil), forCellReuseIdentifier: "RunningTradeRowCell")
        tableView.isScrollEnabled = false
        tableView.reloadData()
    }
    
    @IBAction func switchButtonAct(_ sender: Any) {
        isFilterActive.toggle()
        if isFilterActive {
            if filterList.count > 0 {
                symbolList = filterList
                count = 3
            } else {
                symbolList = symbolListAll
            }
        } else {
            symbolList = symbolListAll
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = titleValue[indexPath.row]
        
        return cell
    }
    
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.timeStamp?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RunningTradeRowCell", for: indexPath) as? RunningTradeRowCell else {
            return UITableViewCell()
        }
        
        cell.setupColumnWidth(value: view.frame.width)
        
        if dataList?.timeStamp?.count != 0 {
            let count = (dataList?.timeStamp?.count != 0 ? dataList?.timeStamp?.count : 0) ?? 0
            if count != 0 {
                let idx = (count - 1) - indexPath.row
                let type = dataList?.timeStamp?[idx].type
                let lastValue = dataList?.timeStamp?[idx - 1].price ?? 0
                let value = dataList?.timeStamp?[idx].price ?? 0
                let chgValue = dataList?.timeStamp?[idx].chg ?? 0
                let price = Double(round(10 * value) / 10)
                
                if type != "-" {
                    cell.stockLabel.text = type
                    cell.priceLabel.text = String(price)
                    cell.volumeLabel.text = dataList?.volume?[idx].value.thousandSeparatorFormat()
                    cell.chgLabel.text = chgValue.percentageFormat()
                    cell.timeLabel.text = dataList?.timeStamp?[idx].value.formattedDateString()
                    if lastValue < value {
                        cell.actLabel.text = "SD"
                        cell.actLabel.textColor = #colorLiteral(red: 1, green: 0.2012884617, blue: 0.196865201, alpha: 1)
                    } else {
                        cell.actLabel.text = "BU"
                        cell.actLabel.textColor = #colorLiteral(red: 0, green: 0.6426771879, blue: 0.02251676843, alpha: 1)
                    }
                } else {
                    cell.stockLabel.text = "-"
                    cell.priceLabel.text = "-"
                    cell.volumeLabel.text = "-"
                    cell.chgLabel.text = "-"
                    cell.timeLabel.text = "-"
                    cell.actLabel.text = "-"
                    cell.actLabel.textColor = #colorLiteral(red: 1, green: 0.2012884617, blue: 0.196865201, alpha: 1)
                }
            }
        }
        
        return cell
    }
}

extension HomeVC: HandleFilter {
    func selectedFilter(data: [String]) {
        symbolList = data
        filterList = data
        switchBtn.isOn = true
        
        count = 3
    }
}
