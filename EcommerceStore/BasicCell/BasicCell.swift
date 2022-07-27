import UIKit

final class BasicCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func bind(item: Item) {
        titleLabel.text = item.productName
        subtitleLabel.text = item.price
    }
}
