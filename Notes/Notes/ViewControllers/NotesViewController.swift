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
        self.notesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.notebook.remove(with: self.notebook[indexPath.row].uid)
        tableView.deleteRows(at: [indexPath], with: .left)
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
        let cellIdentifier = "noteCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            let note = self.notebook[indexPath.row]
            
            cell.textLabel?.text = note.title
            cell.detailTextLabel?.text = note.content
            cell.imageView?.image = self.rectImage(with: note.color)
            
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            let note = self.notebook[indexPath.row]
            
            cell.textLabel?.text = note.title
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.detailTextLabel?.text = note.content
            cell.detailTextLabel?.numberOfLines = 5
            cell.detailTextLabel?.textColor = .lightGray
            cell.imageView?.image = self.rectImage(with: note.color)
            
            return cell
        }
        
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
    
    func rectImage(with color: UIColor) -> UIImage {
        let size: CGFloat = 20.0
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        return img
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
