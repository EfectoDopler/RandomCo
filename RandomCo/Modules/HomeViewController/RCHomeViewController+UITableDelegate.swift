//
//  RCHomeViewController+UITableDelegate.swift.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation
import UIKit

extension RCHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getUserCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "RCBasicTableViewCell") as! RCBasicTableViewCell
        cell.configureCell(model: viewModel.getUserFor(index: indexPath.row))
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !viewModel.getIsFavouriteMode() {
            let off = scrollView.contentOffset.y
            floatingButton.frame = CGRect(
                x: btnX,
                y: off + btnY,
                width: floatingButton.frame.size.width,
                height: floatingButton.frame.size.height)
        }
    }
}
