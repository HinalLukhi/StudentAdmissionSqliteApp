
import UIKit

class ChangePassword: UIViewController {
    
    var stud:Student?
    
    public let myTextField1:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter old password"
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 6
        textField.textAlignment = .left
        return textField
    }()
    public let myTextField2:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter new password"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 6
        textField.textAlignment = .left
        return textField
    }()
    private let MyButton:UIButton={
        let button=UIButton()
        button.setTitle("Change", for: .normal)
        button.addTarget(self, action: #selector(OnbtnClick), for: .touchUpInside)
        button.backgroundColor = .green
        button.layer.cornerRadius = 15
        return button
    }()
   
    @objc func OnbtnClick()
    {
        if (myTextField1.text == stud?.pwd)
        {
            if let s: Student = stud{
                let i = s.id
                let p = myTextField2.text!
                SqliteHandler.shared.updatepwd(pwd: p , id : i){ [weak self] success in
                    if success {
                        print("Change password Successfully, received message at VC")
                        self?.resetFields()
                        self?.navigationController?.popViewController(animated: true)
                        self?.navigationController?.popViewController(animated: true)
            
                    }else {
                        print("pwd Failed, received message at VC")
                    }
                }
            }
        }else{
            print("no")
        }

    }
    func resetFields()
    {
        stud = nil
        myTextField1.text = ""
        myTextField2.text = ""
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        title = "Chnage password"
        view.addSubview(myTextField1)
        view.addSubview(myTextField2)
        view.addSubview(MyButton)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTextField1.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.width - 40, height: 40)
        myTextField2.frame = CGRect(x: 20, y:myTextField1.bottom + 10, width: view.width - 40, height: 40)
        MyButton.frame = CGRect(x: 20, y: myTextField2.bottom + 10, width: view.width - 40, height: 40)
    }
}
