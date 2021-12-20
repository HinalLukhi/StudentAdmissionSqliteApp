
import UIKit

class ViewDetails: UIViewController {

    var stud:Student?
    private let myDetails:UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.text=""
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Details"
        view.addSubview(myDetails)
        if let s : Student = stud{
            let id = s.id
            let name = s.name
            let email = s.email
            let Class = s.Class
        myDetails.text = "SPID : \(id) \nName: \(name) \nEmail: \(email) \nClass: \(Class)"
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myDetails.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.width - 40, height: 100)
    }

}
