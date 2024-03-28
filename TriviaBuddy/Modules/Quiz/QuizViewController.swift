//
//  QuizViewController.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import UIKit

final class QuizViewController: TBQuizViewController {

    typealias ViewModel = QuizViewModel

    private var viewModel: ViewModel!
    private var questions: [QuizItem] = []
    private var questionIndex: Int = 1

    init(viewModel: ViewModel!) {
        super.init()
        self.viewModel = viewModel
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupView() {
        super.setupView()
        layout = LayoutType.quiz.layout
        actionButton.title = "Check"
        showActionButton(true)
        collectionView.registerCells([QuizCell.self])
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }

    private func bind() {
        viewModel.$questions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] questions in
                guard let self = self else { return }
                self.questions = questions
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

    @objc
    private func actionTapped(_ sender: TBButton) {
        if questionIndex <= questions.count - 1 {
            questionIndex += 1
            goToNextQuestion()
        }
    }

    private func goToNextQuestion() {
        let newProgress = Float(questionIndex) / 10
        progressView.setProgress(newProgress, animated: true)
        let indexPath = IndexPath(item: 0, section: questionIndex - 1)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc
    private func dismissTapped(_ sender: TBButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: .resetValues, object: nil)
    }

}

extension QuizViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return questions.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = questions[indexPath.section]
        let cell: QuizCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.sections = viewModel.sections
        cell.question = question
        cell.didSelectItem = { [weak self] answer in
            guard let self = self else { return }
        }
        return cell
    }

}
