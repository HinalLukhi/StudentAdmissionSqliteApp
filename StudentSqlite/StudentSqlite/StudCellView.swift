
import UIKit

class StudCellView: UITableViewCell {
    private let myLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    func setupCell(stud: Student)
    {
        contentView.addSubview(myLabel)
        myLabel.frame = CGRect(x: 10, y: 0, width: 300, height: 50)
        myLabel.text = "\(stud.id) \t|\t \(stud.name) \t| \t\(stud.Class)"
    }
}
