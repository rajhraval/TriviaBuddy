//
//  QuestionCell.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import UIKit

class QuestionCell: UICollectionViewCell {

    @UseAutoLayout
    private var containerView: UIView = {
        let view = UIView()
        return view
    }()

    @UseAutoLayout
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a question"
        label.font = .h3
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        questionLabel.text = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupView()
    }

    private func setupView() {
        contentView.addSubview(containerView)
        containerView.pinToTopBottomLeadingTrailingEdgesWithConstant()
        containerView.addSubview(questionLabel)
        questionLabel.pinToTopBottomLeadingTrailingEdgesWithConstants()
    }

    func configureCell(for question: String) {
        questionLabel.text = question.showPlainString
    }

}
