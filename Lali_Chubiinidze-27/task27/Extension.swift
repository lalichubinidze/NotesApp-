import Foundation

extension RemindersVC : RemindersDetailsVCProtocol {
    func DidSaveReminder() {
        remindersList = connectfiles(path: remindersPath)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

func connectfiles(path: String) ->[String] {
    let manager = FileManager.default
    var filesLastPaths = [String]()
    guard let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return ["nil"]
    }
    let filesDirUrl = documentsUrl.appendingPathComponent(path)
    do{
        filesLastPaths = try manager.contentsOfDirectory(at: filesDirUrl,includingPropertiesForKeys: nil).map{$0.lastPathComponent}

    }catch{
        print(error)
    }
    return filesLastPaths
}

func deletefile(direPath: String,filepath:String){
    let manager = FileManager.default
    let dirUrl = getDocymentsUrl()
    let reminderDirUrl =  dirUrl.appendingPathComponent(direPath)
    do {
        try manager.removeItem(at: reminderDirUrl.appendingPathComponent("\(filepath)"))
    }catch{
        print(error)
    }
}
func getDocymentsUrl() -> URL{
    let manager = FileManager.default
    guard let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return URL(string: "error")!
    }
    return documentsUrl
}
