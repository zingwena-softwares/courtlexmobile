import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/note.dart';
import 'package:courtlexmobile/screens/notes.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/note_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'login.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _typeSubjectController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  bool _loading = false;

  void _saveNote() async {
    ApiResponse response = await saveNote(_typeController.text, _typeSubjectController.text,_titleController.text,_dateController.text, _detailController.text);
    if (response.data!= null){
      //Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Notes()), (route) => false);

    }
    else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }
  // edit note
  void _editNote(int noteId) async {
    ApiResponse response = await editClient(noteId,_typeController.text, _typeSubjectController.text, _titleController.text,_dateController.text, _detailController.text);
    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Notes()), (route) => false);
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }


  @override
  void initState() {
    if(widget.note != null){
      _typeController.text = widget.note!.type!;
      _typeSubjectController.text = widget.note!.type_subject!;
      _titleController.text = widget.note!.title!;
      _dateController.text = widget.note!.date!;
      _detailController.text = widget.note!.detail!;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.note!=null? Text("Edit  Note"):Text("Add New Note"),
        centerTitle: true,
      ),
      body: _loading ? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _typeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Note Type",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Note Title",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _typeSubjectController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Note Subject",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.name,
                controller: _dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Note Date",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _detailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Note Detail",

                ),
              ),

              SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed:(){
                    if (widget.note == null) {
                      _saveNote();
                    } else {
                      _editNote(widget.note!.id ?? 0);
                    }
                  },
                  // _saveClient,
                  child: widget.note!=null? Text("Update Note"):Text("Save Note")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
