//
//  RCHomeViewController.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import UIKit
import Combine
import CoreLocation

class RCHomeViewController: RCBaseViewController {

    // MARK: - VARIABLE DECLARATION
    
    @IBOutlet weak var searchNameTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    var floatingButton = UIButton(type: .custom)
    let btnX = UIScreen.main.bounds.size.width - 110
    var btnY = UIScreen.main.bounds.size.height
    var filterSelectorSheet: UIAlertController!
    
    var viewModel: RCHomeViewModel
    var locationManager: CLLocationManager!
    
    // MARK: - CONSTRUCTOR
    
    init(favouriteMode: Bool) {
        viewModel = RCHomeViewModel(favouriteMode: favouriteMode)
        super.init(nibName: "RCHomeViewController", bundle: nil)
        title = favouriteMode ? "Favourites" : "Home"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIFE CICLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        showLoaderView()
        viewModel.obtainUsersInformation()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.getIsFavouriteMode() {
            viewModel.obtainUsersInformation()
        }
    }
    
    // MARK: - BIND VIEW COMPONENTS WITH VIEWMODEL
    
    override func bindComponentsToViewModel() {
        viewModel.$showUsers
           .sink { [weak self] user in
            DispatchQueue.main.async {
                self?.table.reloadData()
                self?.hideLoaderView()
            }
           }
        .store(in: &subscriptions)
        viewModel.favouriteUsers.$results
            .sink { [weak self] user in
                DispatchQueue.main.async {
                self?.table.reloadData()
                self?.hideLoaderView()
                }
           }
        .store(in: &subscriptions)
    }
    
    // MARK: - VIEW CONFIGURATION
    
    private func configureView() {
        if !viewModel.getIsFavouriteMode() {
            configureFloatingButton()
        }
        configureActionSheet()
        configureTable()
    }
    
    private func configureActionSheet() {
        filterSelectorSheet = UIAlertController(title: nil, message: "Filter by", preferredStyle: .actionSheet)

        let noneAction = UIAlertAction(title: "None", style: .default) { [weak self] _ in
            self?.actionSheetHandler(type: .none)
        }
        let nameAction = UIAlertAction(title: "Name Asc", style: .default){ [weak self] _ in
            self?.actionSheetHandler(type: .asc)
        }
        let genderMaleAction = UIAlertAction(title: "Gender male", style: .default){ [weak self] _ in
            self?.actionSheetHandler(type: .male)
        }
        let genderFemaleAction = UIAlertAction(title: "Gender female", style: .default) {
            [weak self] _ in
            self?.actionSheetHandler(type: .female)
        }
        let locationAction = UIAlertAction(title: "Less 1KM", style: .default) {
            [weak self] _ in
            self?.checkLocation()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        filterSelectorSheet.addAction(noneAction)
        filterSelectorSheet.addAction(nameAction)
        filterSelectorSheet.addAction(genderMaleAction)
        filterSelectorSheet.addAction(genderFemaleAction)
        filterSelectorSheet.addAction(locationAction)
        filterSelectorSheet.addAction(cancelAction)
    }
    
    private func actionSheetHandler(type: RCHomeStatusFilter) {
        if viewModel.getUserCount() > 0 {
            table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        viewModel.addFilter(type: type)
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.register(UINib(nibName: "RCBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "RCBasicTableViewCell")
        
        if !viewModel.getIsFavouriteMode() {
            table.addSubview(floatingButton)
        }
    }
    
    private func configureFloatingButton() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        let aux2 = tabBarController?.tabBar.frame.size.height
        btnY = btnY - topPadding - bottomPadding - (aux2 ?? 0.0) - 70 - (55 * 2)
        floatingButton = UIButton.createRoundedCustomButton(
            posX: btnX,
            posY: btnY,
            icon: "add")
        floatingButton.addTarget(self, action: #selector(self.addButtonTouchUp(_:)), for: .touchUpInside)
    }

    // MARK: - TOUCHUP ACTION
    
    @IBAction func filterByTouchUp(_ sender: Any) {
        present(filterSelectorSheet, animated: true, completion: nil)
    }
    
    @objc func addButtonTouchUp(_ sender: UIButton) {
        showLoaderView()
        viewModel.obtainUsersInformation()
    }

    @IBAction func searchNameChanged(_ sender: UITextField) {
        if viewModel.getUserCount() > 0 {
            table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        viewModel.obtainSearchName(name: sender.text)
    }
}

// MARK: - RCBasicTableViewCellProtocol IMPLEMENTATION

extension RCHomeViewController: RCBasicTableViewCellProtocol {
    func imagePressed(id: Int) {
        let vc = RCUserInfoViewController(userInfo: viewModel.getUserInfoFor(index: id))
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func removeItem(id: Int) {
        showLoaderView()
        viewModel.removeItem(index: id)
    }
    
    func favourite(id: Int) {
        viewModel.favouriteItem(index: id)
    }
}
