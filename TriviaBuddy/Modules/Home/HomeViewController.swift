//
//  HomeViewController.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 28/01/24.
//

import UIKit

class HomeViewController: TBCollectionViewController {

    typealias ViewModel = HomeViewModel

    private var viewModel: ViewModel!
    private var categories: [Category] = []
    private var selectedIndexPath: IndexPath?

    init(viewModel: ViewModel = HomeViewModel()) {
        super.init()
        self.viewModel = viewModel
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func setupView() {
        super.setupView()
        layout = createLayout()
        navigationView.title = "Trivia Buddy"
        navigationView.subtitle = "Challenge yourself"
        actionButton.title = "Start Quiz"

        collectionView.registerCells([TBButtonCell.self])
        collectionView.registerSupplementaryView([TBHeaderSection.self], ofKind: UICollectionView.elementKindSectionHeader)

        actionButton.setupAccessibility(label: "Start Quiz", hint: "The quiz will start on clicking the button.")
        actionButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
        showActionButton(true)
    }

    private func bind() {
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else { return }
                self.categories = categories
                collectionView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                handleLoading(for: state)
            }
            .store(in: &cancellables)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let homeSection = HomeSection(rawValue: sectionIndex) else { return nil }

            let itemSize = NSCollectionLayoutSize(widthDimension: homeSection.itemWidth, heightDimension: homeSection.itemHeight)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: homeSection.groupWidth, heightDimension: homeSection.groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
            return section
        }
        return layout
    }


    @objc
    private func startQuiz(_ sender: TBButton) {
        let quizComponent = QuizComponent(questions: 10, category: 11, difficulty: "easy", type: "multiple")
        let viewModel = QuizViewModel(quizComponent: quizComponent)
        let quizViewController = QuizViewController(viewModel: viewModel)
        present(quizViewController, animated: true)
    }

}


extension HomeViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        return section.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .questions:
            let question = Questions.allCases[indexPath.item]
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.itemButton.setupAccessibility(label: "\(question.rawValue) questions", hint: "Select \(question.rawValue) questions for the quiz.")
            cell.configureButton("\(question.rawValue)", color: .systemIndigo)
            return cell
        case .category:
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.itemButton.setupAccessibility(label: "Select Category", hint: "Select Category questions for the quiz.")
            cell.configureButton("Select Category", color: .systemBlue)
            return cell
        case .difficulty:
            let difficulty = Difficulty.allCases[indexPath.item]
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureButton(difficulty.display, color: .systemPink)
            cell.itemButton.setupAccessibility(label: "\(difficulty.rawValue) level for the quiz", hint: "Select difficulty of the questions for the quiz.")
            return cell
        case .type:
            let type = CategoryType.allCases[indexPath.item]
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureButton(type.display, color: .systemGreen)
            cell.itemButton.setupAccessibility(label: "\(type.display)", hint: "Select type of the questions for the quiz.")
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = viewModel.sections[indexPath.section]
        let header: TBHeaderSection = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
        header.configureHeader(for: section)
        return header
    }

}
