//
//  SearchListViewController.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa
import RxSwift
import RxCocoa

class SearchListViewController: NSViewController {
    private var searchField: NSSearchField!
    private var separatorView: NSView!
    private var tableView: NSTableView!
    
    private var viewModel: SearchListViewModel = .init()
    private var disposeBag: DisposeBag = .init()
    
    override func loadView() {
        let visualEffectView: NSVisualEffectView = .init()
        visualEffectView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        view = visualEffectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchField()
        configureSeparatorView()
        configureTableView()
        bind()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        tableView.reloadData()
    }
    
    private func configureSearchField() {
        searchField = .init()
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.topAnchor.constraint(equalTo: view.topAnchor,
                                         constant: 30).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                             constant: 10).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                              constant: -10).isActive = true
    }
    
    private func configureSeparatorView() {
        separatorView = .init()
        separatorView.wantsLayer = true
        separatorView.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.2).cgColor
        view.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func configureTableView() {
        tableView = .init()
        tableView.headerView = nil
        tableView.style = .sourceList
        tableView.delegate = self
        tableView.dataSource = self
        tableView.wantsLayer = true
        tableView.layer?.backgroundColor = .clear
        
        let identifier: NSUserInterfaceItemIdentifier = .init("SearchResult")
        let column: NSTableColumn = .init(identifier: identifier)
        tableView.addTableColumn(column)
        tableView.register(NSNib(nibNamed: "SearchListTableCellView", bundle: .main), forIdentifier: identifier)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Open URL", action: #selector(openDocURL(_:)), keyEquivalent: ""))
        tableView.menu = menu
        
        let scrollView: NSScrollView = .init()
        scrollView.documentView = tableView
        scrollView.autohidesScrollers = true
        scrollView.hasVerticalScroller = true
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func bind() {
        viewModel.searchData
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { (weakSelf, _) in
                    weakSelf.tableView.reloadData()
                },
                onError: { [weak self] error in
                    self?.presentAlert(error)
                }
            )
            .disposed(by: disposeBag)
        
        searchField.rx.text
            .withUnretained(viewModel)
            .subscribe { (weakObject, text) in weakObject.request(text: text ?? "") }
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(_ error: Error) {
        let alert: NSAlert = .init(error: error)
        alert.runModal()
    }
    
    @objc func openDocURL(_ sender: AnyObject) {
        let clickedRow = tableView.clickedRow
        guard let cell = tableView.view(atColumn: 0, row: clickedRow, makeIfNecessary: false) as? SearchListTableCellView,
              let url = cell.searchData?.docURL
              else { return }
        NSWorkspace.shared.open(url)
    }
}

extension SearchListViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        viewModel.getSearchData().count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell: SearchListTableCellView
        if let rcell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? SearchListTableCellView {
            cell = rcell
        } else {
            cell = SearchListTableCellView.fromNib()
        }
        
        let searchData = viewModel.getSearchData()
        
        guard row < searchData.count else {
            cell.configure(.getSampleData())
            return cell
        }
        
        cell.configure(searchData[row])
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 70
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let splitViewController = parent as? SearchSplitViewController else {
            return
        }
        guard let imageViewController = splitViewController.imageViewController else {
            return
        }
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        
        let clickedRow = tableView.selectedRow
        
        guard let cell = tableView.view(atColumn: 0, row: clickedRow, makeIfNecessary: false) as? SearchListTableCellView else {
            return
            
        }
        
        guard let searchData = cell.searchData else {
            return
        }
        
        imageViewController.update(searchData)
        
    }
}
