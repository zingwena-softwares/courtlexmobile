import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/models/schedule.dart';
import 'package:courtlexmobile/screens/schedules.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/schedule_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'login.dart';

class ScheduleDetails extends StatefulWidget {
  const ScheduleDetails({Key? key, this.schedule}) : super(key: key);
  final Schedule? schedule;

  @override
  _ScheduleDetailsState createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails>  with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  TextEditingController _typeController = TextEditingController();
  TextEditingController _typeSubjectController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  bool _loading = false;

  List<Client> _clientsNames = [];
  Future<List<Client>> _getClientsNames() async {
    final clients = await getClientsNames();
    if (_clientsNames.length == 0)
      _clientsNames.addAll(clients);
    return _clientsNames.toList();
  }

  void _handleDeleteSchedule(int scheduleId) async {
    ApiResponse response = await deleteSchedule(scheduleId);
    if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    }
    else if(response.error==null){
      if(mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.data}')));
      }
    }
    else {
      if(mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }

    }
  }

  @override
  void initState() {
    super.initState();
    _typeController = new TextEditingController(text: widget.schedule!.type);
    _typeSubjectController =new TextEditingController(text: widget.schedule!.type_subject);
    _titleController =new TextEditingController(text: widget.schedule!.title);
    _dateController = new TextEditingController(text: widget.schedule!.date);
    _detailController = new TextEditingController(text: widget.schedule!.detail);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () =>  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Schedules()), (route) => false),
                  ),
                  Text(
                    'Schedule Details',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  InkWell(child: Icon(Icons.share_outlined), onTap: () {}),
                  SizedBox(
                    width: 20.0,
                  ),
                  InkWell(child: Icon(Icons.edit),
                      onTap: () {
                        List<String?> list = _clientsNames.map((e) => e.name).toList();
                        List<String> filter(List<String?> input) {
                          input.removeWhere((e) => e == null);
                          return List<String>.from(input);
                        }
                        List<String> filteredList = filter(list);
                        /*  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddNote(
                          clients: filteredList,
                          notes: widget.note,
                        )));*/
                      }),
                  SizedBox(
                    width: 20.0,
                  ),
                  InkWell(
                      child: Icon(Icons.delete),
                      onTap: () {
                        showDialog<String>(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            insetPadding: EdgeInsets.all(10),
                            content: const Text(
                                'Are you sure , you want to delete the Schedule. '
                                    'Records Associated with this Note will not be deleted'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _handleDeleteSchedule(widget.schedule!.id ?? 0);
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Schedules()), (route) => false);
                                  /*   _onClientDelete(client);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ClientsList()),*/
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
              SizedBox(
                height: 30,
              ),

              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:160,
                        child: Text(
                          '${widget.schedule!.title}',
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      SizedBox(
                        width:160,
                        child: Text(
                          '${widget.schedule!.type}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        Container(
                          color:Colors.red,
                          height: 25,
                          width: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.schedule!.date}",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color:  Colors.white

                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Container(
                            color:  Colors.blue,
                            height: 25,
                            width: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${widget.schedule!.date}",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      color:  Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        ],
        toolbarHeight: 200,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: Colors.red,
          tabs: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('BASIC DETAILS'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('CLIENT DETAILS'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            padding: new EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _typeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Schedule Type ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _typeSubjectController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Schedule Subject ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Schedule Title ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Schedule Date',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _detailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Schedule Detail ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text("Nothing to display yet"),
          ),

        ],
      ),
    );
  }
}
