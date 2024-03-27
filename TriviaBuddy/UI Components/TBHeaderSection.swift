//
//  TBHeaderSection.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import UIKit

protocol HeaderSection {
    var title: String { get }
}

class TBHeaderSection: UICollectionReusableView {

    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var primaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pSmall()
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
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
        label.text = nil
    }

    private func setup() {
        setupView()
    }

    private func setupView() {
        addSubview(containerView)
        containerView.pinToTopBottomLeadingTrailingEdgesWithConstants()
        containerView.addSubview(label)
        label.pinToTopBottomLeadingTrailingEdgesWithConstants(verticalConstant: 8)
    }

    func configureHeader(for section: HeaderSection) {
        label.text = section.title
    }

}

