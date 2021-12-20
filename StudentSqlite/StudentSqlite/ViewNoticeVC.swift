
import UIKit

class ViewNoticeVC: UIViewController {

    
    private var noticeArray = [Notice]()
    private let myTableView = UITableView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
        
        noticeArray =  SqliteHandler.shared.fetchData()
        myTableView.reloadData()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Notice Board"
        view.backgroundColor = .white
       
        setupTableView()
        
        view.addSubview(myTableView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        myTableView.frame = CGRect(x: 0, y: 100, width:view.frame.size.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
    
}

extension ViewNoticeVC :UITableViewDataSource,UITableViewDelegate {
    private func setupTableView()
    {
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let n1 = noticeArray[indexPath.row]
        cell.textLabel?.text = "\(n1.title) \t | \t \(n1.date) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click")
        let vc = NoticeVC()
        vc.n1 = noticeArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
