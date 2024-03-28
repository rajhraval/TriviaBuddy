//
//  HomeViewController.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 28/01/24.
//

import Combine
import UIKit

class HomeViewController: TBCollectionViewController {

    typealias ViewModel = HomeViewModel

    private var viewModel: ViewModel!
    
    private var categories: [Category] = []


    private var selectedQuestionIndexPath: IndexPath?
    private var difficultyQuestionIndexPath: IndexPath?
    private var answerTypeQuestionIndexPath: IndexPath?

    init(viewModel: ViewModel = HomeViewModel()) {
        super.init()
        self.viewModel = viewModel
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(resetValues), name: .resetValues, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @objc
    private func resetValues(_ notification: Notification) {
        viewModel.resetValues()
        Log.info("Current Settings: Category: \(String(describing: viewModel.selectedCategory)), Difficulty: \(viewModel.selectedDifficulty), Answer Type: \(viewModel.selectedAnswerType), Questions: \(viewModel.selectedQuestions)")
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 24, bottom: 18, trailing: 24)
            return section
        }
        return layout
    }


    @objc
    private func startQuiz(_ sender: TBButton) {
        let quizComponent = QuizComponent(questions: viewModel.selectedQuestions, category: viewModel.selectedCategory, difficulty: viewModel.selectedDifficulty, type: viewModel.selectedAnswerType)
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
            let questions = Questions.allCases
            let question = questions[indexPath.item]
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.itemButton.setupAccessibility(label: "\(question.rawValue) questions", hint: "Select \(question.rawValue) questions for the quiz.")
            cell.didSelectItem = { [weak self] in
                guard let self = self else { return }
                deselect(for: selectedQuestionIndexPath, indexPath: indexPath)
                selectedQuestionIndexPath = indexPath
                cell.itemButton.isSelected = true
                let selectedQuestion = questions[selectedQuestionIndexPath?.item ?? 0]
                viewModel.selectedQuestions = selectedQuestion.rawValue
            }
            cell.configureButton("\(question.rawValue)", color: .systemIndigo)
            return cell
        case .category:
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.itemButton.setupAccessibility(label: "Select Category", hint: "Select Category questions for the quiz.")
            cell.configureMenuButton("Select Category", color: .systemBlue, with: categories)
            cell.didSelectCategory = { [weak self] categoryID in
                guard let self = self else { return }
                cell.itemButton.isSelected = true
                viewModel.selectedCategory = categoryID
            }
            return cell
        case .difficulty:
            let difficulties = Difficulty.allCases
            let difficulty = difficulties[indexPath.item]
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureButton(difficulty.display, color: .systemPink)
            cell.itemButton.setupAccessibility(label: "\(difficulty.rawValue) level for the quiz", hint: "Select difficulty of the questions for the quiz.")
            cell.didSelectItem = { [weak self] in
                guard let self = self else { return }
                deselect(for: difficultyQuestionIndexPath, indexPath: indexPath)
                difficultyQuestionIndexPath = indexPath
                cell.itemButton.isSelected = true
                let selectedDifficulty = difficulties[difficultyQuestionIndexPath?.item ?? 0]
                viewModel.selectedDifficulty = selectedDifficulty.rawValue
            }
            return cell
        case .type:
            let categories = CategoryType.allCases
            let type = categories[indexPath.item]
            let cell: TBButtonCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureButton(type.display, color: .systemGreen)
            cell.itemButton.setupAccessibility(label: "\(type.display)", hint: "Select type of the questions for the quiz.")
            cell.didSelectItem = { [weak self] in
                guard let self = self else { return }
                deselect(for: answerTypeQuestionIndexPath, indexPath: indexPath)
                answerTypeQuestionIndexPath = indexPath
                cell.itemButton.isSelected = true
                let selectedCategory = categories[answerTypeQuestionIndexPath?.item ?? 0]
                viewModel.selectedAnswerType = selectedCategory.rawValue
            }
            return cell
        }
    }
    
    private func deselect(for selectedIndexPath: IndexPath?, indexPath: IndexPath) {
        if let selectedIndexPath, selectedIndexPath != indexPath {
            let previousCell = collectionView.cellForItem(at: selectedIndexPath) as? TBButtonCell
            previousCell?.itemButton.isSelected = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = viewModel.sections[indexPath.section]
        let header: TBHeaderSection = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
        header.configureHeader(for: section)
        return header
    }

}

