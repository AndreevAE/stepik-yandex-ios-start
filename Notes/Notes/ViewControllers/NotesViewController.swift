//
//  NotesViewController.swift
//  Notes
//
//  Created by Admin on 21/07/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    
    private var notebook = FileNotebook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes"

        self.notesTableView.delegate = self
        self.notesTableView.dataSource = self
        
        self.setupNavigationBar()
        // TODO: DEBUG notes
        self.loadPlaceholderNotes()
    }

}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController(initNote: self.notebook[indexPath.row]) { [weak self] savedNote in
            let uid = self?.notebook[indexPath.row].uid
            self?.notebook.remove(with: uid ?? "1")
            self?.notebook.add(savedNote)
            self?.notesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        self.navigationController?.pushViewController(noteEditorViewController, animated: true)
    }
    
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "noteCell")
        
        cell.textLabel?.text = self.notebook[indexPath.row].title
        cell.detailTextLabel?.text = self.notebook[indexPath.row].content
        // TODO: image view from note color
        //        cell.imageView
        
        return cell
    }
    
    
}


private extension NotesViewController {
    
    func loadPlaceholderNotes() {
        let note1 = Note(title: "Заголовок заметки",
                         content: "Текст заметки, Текст заметки, Текст заметки, Текст заметки, Текст заметки",
                         importance: .regular,
                         selfDestructionDate: nil)
        self.notebook.add(note1)
        
        let note2 = Note(title: "Короткая заметка",
                         content: "Не забыть выключить утюг",
                         importance: .regular,
                         selfDestructionDate: nil)
        self.notebook.add(note2)
        
        let note3 = Note(title: "Длинная заметка",
                         content: "Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки, Очень длинный текст заметки",
                         importance: .regular,
                         selfDestructionDate: nil)
        self.notebook.add(note3)
        
        let note4 = Note(title: "Заголовок заметки - 2",
                         content: "Текст заметки, Текст заметки, Текст заметки, Текст заметки, Текст заметки",
                         importance: .regular,
                         selfDestructionDate: nil)
        self.notebook.add(note4)
        
        let note5 = Note(title: "Короткая заметка",
                         content: "Не забыть выключить утюг",
                         importance: .regular,
                         selfDestructionDate: nil)
        self.notebook.add(note5)
        
        let note6 = Note(title: "Короткая заметка",
                         content: "Не забыть выключить утюг",
                         importance: .regular,
                         selfDestructionDate: nil)
        self.notebook.add(note6)
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit,
                                                                     target: self,
                                                                     action: #selector(onEdit))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                                                      target: self,
                                                                      action: #selector(onAddNote))
        
    }
    
    @objc func onAddNote() {
        let emptyNote = Note(title: "", content: "", importance: .regular, selfDestructionDate: nil)
        
        let noteEditorViewController = NoteEditorViewController(initNote: emptyNote) { [weak self] savedNote in
            self?.notebook.add(savedNote)
            self?.notesTableView.reloadData()
        }
        
        self.navigationController?.pushViewController(noteEditorViewController, animated: true)
    }
    
    @objc func onEdit() {
        self.notesTableView.isEditing = !self.notesTableView.isEditing
    }
    
}
