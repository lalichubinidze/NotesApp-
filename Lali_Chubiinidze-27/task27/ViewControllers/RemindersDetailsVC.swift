import UIKit

protocol RemindersDetailsVCProtocol {
    func DidSaveReminder()
}

class RemindersDetailsVC: UIViewController {
    
    var remiderPath = ""
    let manager = FileManager.default
    var delegate: RemindersDetailsVCProtocol?
    @IBOutlet weak var reminderBodyField: UITextField!
    @IBOutlet weak var reminderTitleField: UITextField!
    var reminderBody = ""
    var reminderTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderBodyField.text = reminderBody
        reminderTitleField.text = reminderTitle
    }
    
    @IBAction func save(_ sender: Any) {
        guard let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        if !reminderBodyField.text!.isEmpty && !reminderTitleField.text!.isEmpty{
            let reminderDirectoryUrl = documentsUrl.appendingPathComponent(remiderPath)
            let reminderUrl = reminderDirectoryUrl.appendingPathComponent("\(reminderTitleField.text!).txt")
            let data = Data(reminderBodyField.text!.utf8)
            manager.createFile(atPath: reminderUrl.path , contents: data)
            delegate?.DidSaveReminder()
            self.dismiss(animated: true)
            LocalLocationManager.register(notification: LocalNotification(id: UUID().uuidString , title: "New Reminder", message: "Reminder -  '\(reminderTitleField.text!)' add successfully"), duration: 3, repeats: false, userInfo: ["aps":["New":"Reminder"]])
        }
        if reminderTitle != reminderTitleField.text && reminderTitle != ""{
            let directoryUrl = getDocymentsUrl()
            let remindersDirectoruUrl = directoryUrl.appendingPathComponent(remiderPath)
            
            do {
                try manager.removeItem(at: remindersDirectoruUrl.appendingPathComponent("\(reminderTitle).txt"))
                delegate?.DidSaveReminder()
                self.dismiss(animated: true)
            }catch{
                print(error)
            }
        }
    }
}
