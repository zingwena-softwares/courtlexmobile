import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/schedule.dart';
import 'package:courtlexmobile/screens/schedules.dart';
import 'package:courtlexmobile/services/schedule_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'login.dart';

class AddScedule extends StatefulWidget {
  const AddScedule({Key? key, this.schedule}) : super(key: key);
  final Schedule? schedule;

  @override
  _AddSceduleState createState() => _AddSceduleState();
}

class _AddSceduleState extends State<AddScedule> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _typeSubjectController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  bool _loading = false;

  void _saveSchedule() async {
    ApiResponse response = await saveSchedule(_typeController.text, _typeSubjectController.text,_titleController.text,_dateController.text, _detailController.text);
    if (response.data!= null){
      //Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Schedules()), (route) => false);

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
  void _editSchedule(int noteId) async {
    ApiResponse response = await updateSchedule(noteId,_typeController.text, _typeSubjectController.text, _titleController.text,_dateController.text, _detailController.text);
    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Schedules()), (route) => false);
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
    if(widget.schedule != null){
      _typeController.text = widget.schedule!.type!;
      _typeSubjectController.text = widget.schedule!.type_subject!;
      _titleController.text = widget.schedule!.title!;
      _dateController.text = widget.schedule!.date!;
      _detailController.text = widget.schedule!.detail!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.schedule!=null? Text("Edit Schedule"):Text("Add New Schedule"),
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
                      if (widget.schedule == null) {
                        _saveSchedule();
                      } else {
                        _editSchedule(widget.schedule!.id ?? 0);
                      }
                    },
                    // _saveClient,
                    child: widget.schedule!=null? Text("Update Note"):Text("Save Note")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
