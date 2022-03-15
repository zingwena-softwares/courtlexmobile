import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/note.dart';
import 'package:courtlexmobile/models/user.dart';
import 'package:courtlexmobile/screens/add_note.dart';
import 'package:courtlexmobile/services/note_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'home.dart';
import 'login.dart';
import 'note_details.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<dynamic> _notesList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrieveNotes() async {
    userId = await getUserId();
    ApiResponse response = await getAllNotes();
    if (response.error == null) {
      setState(() {
        _notesList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
    return null;
  }

  @override
  void initState() {
    retrieveNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () async {
        ApiResponse response = await getUserDetails();
        User user=response.data as User;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(title: appTitle,user: user,)),
        );
      },
    ),
    title: Text("Notes"),
      ),
      body:  _loading
      ? Center(
    child: CircularProgressIndicator(),
      )
      :Column(children: [
    Expanded(
      child: RefreshIndicator(
        onRefresh: () {
          return retrieveNotes();
        },
        child: ListView.builder(
            itemCount: _notesList.length,
            itemBuilder: (BuildContext context, int index) {
              Note note = _notesList[index];
              return Card(
                elevation: 5,
                child: Container(
                    //padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                  isThreeLine: true,
                  leading: Column(
                    children: [Text('${note.date}'), Text('time')],
                  ),
                  title: Container(
                    child: Text(
                      '${note.type}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,

                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Text(
                    '${note.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteDetails(
                                note: note,
                              )),
                    );
                  },
                )),
              );
            }),
      ),
    ),
      ]),
      floatingActionButton: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => AddNote(),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        // heroTag: 'addBreed',
        child: FaIcon(FontAwesomeIcons.plus),
      ),
    ],
      ),
    );
  }
}
