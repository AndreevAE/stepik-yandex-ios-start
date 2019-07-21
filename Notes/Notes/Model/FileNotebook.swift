import Foundation


class FileNotebook {
    
    private(set) var notes: [String: Note] = [:]
    
    
    init() {
        self.notes = [:]
    }
    
    public func add(_ note: Note) {
        self.notes[note.uid] = note
    }
    
    public func remove(with uid: String) {
        self.notes[uid] = nil
    }
    
    subscript (index: Int) -> Note {
        return self.notes.sorted(by: { $0.key < $1.key })[index].value
    }
    
    func save() {
        if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let json = self.notes.map { $0.value.json }
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
                    _ = json.map {
                        let note = Note.parse(json: $0)!
                        self.notes[note.uid] = note
                    }
                }
            } catch let error {
                print("Can't load notes from cache: \(error.localizedDescription)")
            }
        }
    }
}
