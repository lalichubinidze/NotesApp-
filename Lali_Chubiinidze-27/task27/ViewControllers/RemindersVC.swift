import UIKit

class RemindersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let manager = FileManager.default
    var remindersList = [String]()
    var remindersPath = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        remindersList = connectfiles(path: remindersPath)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDetails))
    }

    @objc func addDetails() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersDetailsVC") as! RemindersDetailsVC
        vc.remiderPath = remindersPath
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    
    func getContentsOfTxtFile(index: Int) -> String{
        let documentsUrl = getDocymentsUrl()
        let remindersDirectory = documentsUrl.appendingPathComponent(remindersPath)
        let fileUrl = remindersDirectory.appendingPathComponent(remindersList[index])
        do {
            return try String(contentsOf: fileUrl,encoding: .utf8)
        }catch{
            return "error"
        }
    }
}

extension RemindersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        remindersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
        cell.reminderName.text = remindersList[indexPath.row].replacingOccurrences(of: ".txt", with: "", options: NSString.CompareOptions.literal, range: nil)
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersDetailsVC") as! RemindersDetailsVC
        vc.remiderPath = remindersPath
        vc.reminderBody = getContentsOfTxtFile(index: indexPath.row)
        vc.reminderTitle = remindersList[indexPath.row].replacingOccurrences(of: ".txt", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.navigationController?.present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete {
            tableView.beginUpdates()
            LocalLocationManager.register(notification: LocalNotification(id: UUID().uuidString , title: "New Category", message: "'\(remindersList[indexPath.row])'  deleted"), duration: 3, repeats: false, userInfo: ["aps":["Deleted":"Reminder"]])
            deletefile(direPath: remindersPath, filepath: remindersList[indexPath.row])
            remindersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
}





