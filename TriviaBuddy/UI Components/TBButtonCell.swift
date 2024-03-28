//
//  TBButtonCell.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import UIKit

final class TBButtonCell: UICollectionViewCell {

    var didSelectItem: (() -> Void)?
    var didSelectCategory: ((Int) -> Void)?

    @UseAutoLayout
    private var containerView: UIView = {
        let view = UIView()
        return view
    }()

    @UseAutoLayout
    var itemButton: TBButton = {
        let button = TBButton(style: .chip)
        button.title = "Button"
        button.chipColor = .systemBlue
        button.contentHorizontalAlignment = .center
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemButton.isSelected = false
        itemButton.prepareForReuse()
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
        containerView.addSubview(itemButton)
        itemButton.pinToTopBottomLeadingTrailingEdgesWithConstants()
        itemButton.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
    }

    @objc func selectCategory(_ sender: TBButton) {
        itemButton.isSelected.toggle()
        didSelectItem?()
    }

    func configureButton(_ title: String, color: UIColor) {
        itemButton.title = title.showPlainString
        itemButton.chipColor = color
    }

    func configureMenuButton(_ title: String, color: UIColor, with items: [Category]) {
        itemButton.title = title.showPlainString
        itemButton.chipColor = color
        let menuActions = items.map { item -> UIAction in
            return UIAction(title: item.name, handler: { _ in
                self.itemButton.title = item.name.showPlainString
                self.didSelectCategory?(item.id)
            })
        }
        itemButton.menu = UIMenu(children: menuActions)
        itemButton.showsMenuAsPrimaryAction = true
    }

}
