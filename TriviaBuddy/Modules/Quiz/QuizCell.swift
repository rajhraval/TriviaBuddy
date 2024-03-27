//
//  QuizCell.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 27/03/24.
//

import UIKit

class QuizCell: UICollectionViewCell {

    var didSelectItem: (() -> Void)?

    var sections: [QuizSection] = [] {
        didSet {
            Task { @MainActor in
                collectionView.reloadData()
            }
        }
    }

    var question: QuizItem? {
        didSet {
            Task { @MainActor in
                collectionView.reloadData()
            }
        }
    }

    @UseAutoLayout
    private var containerView: UIView = {
        let view = UIView()
        return view
    }()

    @UseAutoLayout
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, layout: .singleRowWithHeader(header: false))
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        question = nil
        sections = []
    }

    private func setup() {
        setupView()
    }

    private func setupView() {
        contentView.addSubview(containerView)
        containerView.pinToTopBottomLeadingTrailingEdgesWithConstant()
        setupCollectionView()
        collectionView.isScrollEnabled = false
        containerView.addSubview(collectionView)
        collectionView.pinToTopBottomLeadingTrailingEdgesWithConstant()
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCells([TBButtonCell.self, QuestionCell.self])
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let quizSection = QuizSection(rawValue: sectionIndex) else { return nil }

            let itemSize = NSCollectionLayoutSize(widthDimension: quizSection.itemWidth, heightDimension: quizSection.itemHeight)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)

            let groupSize = NSCollectionLayoutSize(widthDimension: quizSection.groupWidth, heightDimension: quizSection.groupHeight)
            let group = quizSection == .question ? NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) : NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])


            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }

}

extension QuizCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        return section.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let question = question else { fatalError("There should be a question") }
        let section = sections[indexPath.section]
        switch section {
        case .question:
            let cell: QuestionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(for: question.question)
            return cell
        case .multipleChoice:
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            let options = question.options
            let option = options[indexPath.row]
            cell.configureButton(option, color: .systemRed)
            cell.didSelectItem = { [weak self] in
                guard let self = self else { return }
                didSelectItem?()
            }
            return cell
        case .boolean:
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            let options = question.options
            let option = options[indexPath.item]
            cell.configureButton(option, color: .systemRed)
            cell.didSelectItem = { [weak self] in
                guard let self = self else { return }
                didSelectItem?()
            }
            return cell
        }
    }


}

extension QuizCell: UICollectionViewDelegate {

}
