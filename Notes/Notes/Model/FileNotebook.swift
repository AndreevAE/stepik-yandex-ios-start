import Foundation


class FileNotebook {
    
    // TODO: dictionary
//    private(set) var notes: [String: Note] = [:]
    private(set) var notes: [Note]
    
    
    init() {
        self.notes = []
    }
    
    // TODO: add onlye unique notes by uid
    public func add(_ note: Note) {
        self.notes.append(note)
    }
    
    public func remove(with uid: String) {
        self.notes.removeAll { (note) -> Bool in
            note.uid == uid
        }
    }
    
    func save() {
        if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let json = self.notes.map { $0.json }
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                let path = cachePath.appendingPathComponent("notebook")
                FileManager.default.createFile(atPath: path.path, contents: data, attributes: nil)
            } catch let error {
                print("Can't save notes to file: \(error.localizedDescription)")
            }
        }
    }
    
    func load() {
        if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let path = cachePath.appendingPathComponent("notebook")
                if let data = FileManager.default.contents(atPath: path.path) {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                    _ = json.map { self.notes.append(Note.parse(json: $0)!) }
                }
            } catch let error {
                print("Can't load notes from cache: \(error.localizedDescription)")
            }
        }
    }
}
