//
//  TBCollectionViewController.swift
//  Meh
//
//  Created by Raj Raval on 09/03/24.
//

import Combine
import UIKit

class ViewModelType: ObservableObject {
    public init() {}
}

protocol ViewModelInclusion: AnyObject {
    associatedtype ViewModel: ViewModelType
}

class TBCollectionViewController: UIViewController, ViewModelInclusion {
    typealias ViewModel = ViewModelType

    private var showNavigationView: Bool = true
    private var showActionButton: Bool = true

    var cancellables: Set<AnyCancellable> = []

    @UseAutoLayout open var actionButton: TBButton = {
        let button = TBButton(style: .text)
        button.title = "Hello"
        button.backgroundColour = .orange
        return button
    }()

    @UseAutoLayout open var navigationView: TBNavigationView = {
        let navigationView = TBNavigationView()
        return navigationView
    }()

    @UseAutoLayout open var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, layout: .singleRowWithHeader(header: false))
        return collectionView
    }()

    @UseAutoLayout open var loader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        return activityIndicator
    }()

    @UseAutoLayout open var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        return view
    }()

    open var layout: UICollectionViewCompositionalLayout {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }

    public init(with layout: UICollectionViewCompositionalLayout = LayoutType.singleRowWithHeader(header: false).layout) {
        self.layout = layout
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setup() {
        setupView()
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        setupNavigationView()
        setupCollectionView()
        setupActivityIndicator()
        setupEmptyStateView()
        collectionView.registerCells([UICollectionViewCell.self])
    }

    func showNavigationButton(_ show: Bool = true) {
        showNavigationView = show
        navigationView.isHidden = showNavigationView ? false : true
        setupCollectionView()
    }

    func showActionButton(_ show: Bool = false) {
        showActionButton = show
        actionButton.isHidden = showActionButton ? false : true
        setupCollectionView()
    }

    func handleLoading(for state: LoaderState) {
        switch state {
        case .idle:
            loader.stopAnimating()
            collectionView.isHidden = false
            actionButton.isHidden = false
        case .loading:
            loader.startAnimating()
            collectionView.isHidden = true
            actionButton.isHidden = true
        case .error(let error):
            loader.stopAnimating()
            collectionView.isHidden = true
            actionButton.isHidden = true
            emptyStateView.isHidden = false
            emptyStateView.title = "Error"
            emptyStateView.subtitle = error.localizedDescription
        }
    }

    private func setupNavigationView() {
        view.addSubview(navigationView)
        navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationView.pinToLeadingAndTrailingEdgesWithConstant()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        setupActionButton()
        collectionView.topAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        if showActionButton {
            actionButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16).isActive = true
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        } else {
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        collectionView.pinToLeadingAndTrailingEdgesWithConstant()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupActivityIndicator() {
        view.addSubview(loader)
        loader.centerInSuperview()
    }

    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        emptyStateView.centerInSuperview()
    }

    private func setupActionButton() {
        view.addSubview(actionButton)
        actionButton.pinToLeadingAndTrailingEdgesWithConstant(24)
    }

}

extension TBCollectionViewController: UICollectionViewDataSource {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }

}

extension TBCollectionViewController: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
