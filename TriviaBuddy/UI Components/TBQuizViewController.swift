//
//  TBQuizViewController.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 25/03/24.
//

import Combine
import UIKit

class TBQuizViewController: UIViewController, ViewModelInclusion {
    typealias ViewModel = ViewModelType

    private var showActionButton: Bool = true

    var cancellables: Set<AnyCancellable> = []

    @UseAutoLayout open var actionButton: TBButton = {
        let button = TBButton(style: .text)
        button.title = "Hello"
        button.backgroundColour = .orange
        return button
    }()

    @UseAutoLayout open var dismissButton: TBButton = {
        let button = TBButton(style: .icon)
        button.image = UIImage(systemName: "xmark")!
        button.foregroundColour = .systemOrange
        return button
    }()

    @UseAutoLayout open var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemOrange
        progressView.cornerRadius(4)
        return progressView
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
        setupDismissButton()
        setupProgressView()
        setupCollectionView()
        setupActivityIndicator()
        setupEmptyStateView()
        collectionView.registerCells([UICollectionViewCell.self])
    }

    func showActionButton(_ show: Bool = false) {
        showActionButton = show
        actionButton.isHidden = showActionButton ? false : true
        setupCollectionView()
    }

    private func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        dismissButton.setWidthHeightConstraints(24)
        dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    }

    private func setupProgressView() {
        view.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 16).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        progressView.pinToLeadingAndTrailingEdgesWithConstant(24)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        setupActionButton()
        collectionView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16).isActive = true
        if showActionButton {
            actionButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16).isActive = true
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        } else {
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        collectionView.isScrollEnabled = false
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

    func handleLoading(for state: LoaderState) {
        switch state {
        case .idle:
            loader.stopAnimating()
            collectionView.isHidden = false
            actionButton.isHidden = false
            progressView.isHidden = false
        case .loading:
            loader.startAnimating()
            collectionView.isHidden = true
            actionButton.isHidden = true
            progressView.isHidden = true
        case .error(let error):
            loader.stopAnimating()
            collectionView.isHidden = true
            actionButton.isHidden = true
            progressView.isHidden = true
            emptyStateView.isHidden = false
            emptyStateView.title = "Error"
            emptyStateView.subtitle = error.localizedDescription
        }
    }

}

extension TBQuizViewController: UICollectionViewDataSource {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = .blue
        return cell
    }

}

extension TBQuizViewController: UICollectionViewDelegate {

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
