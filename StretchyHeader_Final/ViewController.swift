//
//  ViewController.swift
//  StretchyHeader_Final
//
//  Created by Luis Javier Canto Hurtado on 13/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let toolbarHeight: CGFloat = 250

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var headerView: CustomHeaderView = {
        let headerView = CustomHeaderView(frame: CGRect.zero, backgroundImage: "testBackground", title: "Artículos", iconImage: "article", bgBackgroundColor: UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    // headerHeightConstraint property since we will be changing the height of the table view while scrolling and need to keep a reference to it
    private lazy var headerHeightConstraint: NSLayoutConstraint = {
        let headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 150)
        headerHeightConstraint.isActive = true
        return headerHeightConstraint
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(headerView)
        view.addSubview(tableView)
        constraintsSetUp()
    }
    
    private func constraintsSetUp() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func animateHeader() {
        headerHeightConstraint.constant = toolbarHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ViewController: UIScrollViewDelegate {
    // If the scrollView.contentOffset.y < 0 it means we are pulling downwards. If it is > 0 it means we are pushing upwards.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If we are pulling downwards we want to stretch the header view
        if scrollView.contentOffset.y < 0 {
            // We use the addition assignment operator in our headerHeightConstraint variable every time we scroll up (abs to get the absolute number).
            headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            // Make the color lighter and the icon appear when scrolling up
            headerView.incrementColorAlpha(offset: headerHeightConstraint.constant)
            headerView.incrementHeaderIconAlpha(offset: headerHeightConstraint.constant)
            
            // If we are pulling downwards we want to collapsable the header view
            // The last check ensures that if we scroll up too quickly the header view will stay at 64 points (the standard navigation controller height is 64 points).
        } else if scrollView.contentOffset.y > 0 && headerHeightConstraint.constant >= 65 {
            // We dont want the header view to move up too quickly, that's why we divide by 100.
            headerHeightConstraint.constant -= scrollView.contentOffset.y/100
            // Make the color darker and the icon desapear when scrolling down
            headerView.decrementColorAlpha(offset: scrollView.contentOffset.y)
            headerView.decrementHeaderIconAlpha(offset: headerHeightConstraint.constant)
            // Stop the headerView to being smaller than 65 when scrolling down a lot
            if headerHeightConstraint.constant < 65 {
                headerHeightConstraint.constant = 65
            }
        }
    }
    
    // We set the height constraint back to our original height of 150 and animate the view with damping over 0.4 seconds in this 2 functions.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if headerHeightConstraint.constant > toolbarHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headerHeightConstraint.constant > toolbarHeight {
            animateHeader()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "Número \(indexPath.row)"
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 60
    }
}
