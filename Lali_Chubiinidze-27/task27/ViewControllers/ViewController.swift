import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var allDir  = [String]()
    let manager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        tableView.delegate = self
        tableView.dataSource = self
        connectDirectories()
    }

    @IBAction func addCategoryBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Add", message: "create Category", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: { _ in
            guard let fields = alert.textFields else{
                return
            }
            let directoryNameField = fields[0]
            guard let dirName = directoryNameField.text , !dirName.isEmpty else {
                return
            }
            guard let documentsUrl = self.manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let dirPath = documentsUrl.appendingPathComponent("\(dirName)")
            do{
                try self.manager.createDirectory(at: dirPath, withIntermediateDirectories: true)
                self.connectDirectories()
                LocalLocationManager.register(notification: LocalNotification(id: UUID().uuidString , title: "New Category", message: "Category '\(dirName)' add successfully"), duration: 3, repeats: false, userInfo: ["aps":["New":"Category"]])

            }catch{
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        present(alert,animated: true)
    }

    func connectDirectories() {
        let documentsUrl = getDocymentsUrl()
        do{
            allDir = try manager.contentsOfDirectory(at: documentsUrl,includingPropertiesForKeys: nil).map{$0.lastPathComponent}

        }catch{
            print(error)
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allDir.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryCell",for: indexPath) as! DirectoryCell
        cell.dirName.text = allDir[indexPath.row]
        cell.layer.cornerRadius = 20

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersVC") as! RemindersVC
        vc.title = "Add Reminders"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.remindersPath = allDir[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
