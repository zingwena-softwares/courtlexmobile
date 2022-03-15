import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/case.dart';
import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/screens/add_case.dart';
import 'package:courtlexmobile/screens/cases.dart';
import 'package:courtlexmobile/services/case_service.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'login.dart';

class CaseDetails extends StatefulWidget {
  CaseDetails({Key? key, required this.cases}) : super(key: key);
  final ClientCase cases;

  @override
  _CaseDetailsState createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 5, vsync: this);
  //late ClientCase cases;
  List<Client> _clientsNames = [];

  Future<List<Client>> _getClientsNames() async {
    final clients = await getClientsNames();
    if (_clientsNames.length == 0)
      _clientsNames.addAll(clients);
    return _clientsNames.toList();
  }
  //case basic details controllers
  String case_status = '';
  String case_subject = '';
  //String selected_client = '';
  TextEditingController _clientName = TextEditingController();
  TextEditingController _caseTitle = TextEditingController();
  TextEditingController _caseNumber = TextEditingController();

  //opponent details controllers
  TextEditingController _respLawyerName = TextEditingController();
  TextEditingController _respLawyerPhone = TextEditingController();
  TextEditingController _respLawyerEmail = TextEditingController();
  TextEditingController _respLawyerFirm = TextEditingController();
  TextEditingController _respLawFirmCity = TextEditingController();
  TextEditingController _respLawFirmAddress = TextEditingController();

  //court details controllers
  TextEditingController _courtName = TextEditingController();
  TextEditingController _courtCity = TextEditingController();
  TextEditingController _courtDate = TextEditingController();
  TextEditingController _notes = TextEditingController();
  TextEditingController _addedBy = TextEditingController();

  void _handleDeleteCase(int caseId) async {
    ApiResponse response = await deleteCase(caseId);
    if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      if(mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }

    }
  }
  @override
  void initState() {
    super.initState();
    case_status = widget.cases.case_status!;
    case_subject = widget.cases.case_subject!;
    _clientName= TextEditingController(text: widget.cases.client_name);
    _caseTitle = new TextEditingController(text: widget.cases.case_title);
    _caseNumber = new TextEditingController(text: widget.cases.case_number);

    _respLawyerName =
        new TextEditingController(text: widget.cases.resplawyer_lawfirmname);
    _respLawyerPhone = new TextEditingController(text: widget.cases.resplawyer_phone);
    _respLawyerEmail = new TextEditingController(text: widget.cases.resplawyer_email);
    _respLawyerFirm =
        new TextEditingController(text: widget.cases.resplawyer_lawfirmname);
    _respLawFirmCity =
        new TextEditingController(text: widget.cases.resplawyer_lawfirmcity);
    _respLawFirmAddress =
        new TextEditingController(text: widget.cases.resplawyer_lawfirmaddress);

    _courtName = new TextEditingController(text: widget.cases.court_name);
    _courtCity = new TextEditingController(text: widget.cases.court_city);
    _courtDate = new TextEditingController(text: widget.cases.nextcourt_date);
    _notes = new TextEditingController(text: widget.cases.notes);
    _addedBy = new TextEditingController(text: widget.cases.added_by);
    _getClientsNames();
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
                    onPressed: () =>  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Cases()), (route) => false),
                  ),
                  Text(
                    'Case Details',
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddCase(
                          clients: filteredList,
                          cases: widget.cases,
                        )));
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
                                'Are you sure , you want to delete the Case. '
                                    'Records Associated with this Case will not be deleted'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _handleDeleteCase(widget.cases.id ?? 0);
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Cases()), (route) => false);
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
                    Icons.event_note,
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
                          '${widget.cases.case_title}',
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      SizedBox(
                        width:160,
                        child: Text(
                          '${widget.cases.client_name}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '${widget.cases.nextcourt_date.toString().substring(0, 10)}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            if(widget.cases.case_status=="CLOSED"){
                              showDialog<String>(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  insetPadding: EdgeInsets.all(10),
                                  content: const Text(
                                      'Do you want to open the Case'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        openCase(widget.cases.id!);
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Cases()), (route) => false);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            }

                          },
                          child: Container(
                            color: widget.cases.case_status == "OPEN"
                                ? Colors.red
                                : Colors.white,
                            height: 25,
                            width: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "OPEN",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: widget.cases.case_status == "OPEN"
                                        ? Colors.white
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(widget.cases.case_status=="OPEN"){
                              showDialog<String>(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  insetPadding: EdgeInsets.all(10),
                                  content: const Text(
                                      'Do you want to Open the Case'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        closeCase(widget.cases.id!);
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Cases()), (route) => false);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            }

                          },
                          child: Container(
                            color: widget.cases.case_status == "CLOSED"
                                ? Colors.green
                                : Colors.white,
                            height: 25,
                            width: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "CLOSED",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: widget.cases.case_status == "CLOSED"
                                        ? Colors.white
                                        : Colors.green,
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
              child: Text('CASE DETAILS'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('EVIDENCES'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('SCHEDULE'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('NOTES'),
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.0),
                    TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.name,
                      controller: _caseTitle,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Case Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Case Title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.name,
                        controller: _clientName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Client Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Case Number';
                          }
                          return null;
                        }),
                    SizedBox(height: 16.0),
                    TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.name,
                        controller: _caseNumber,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Case Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Case Number';
                          }
                          return null;
                        }),
                    SizedBox(height: 16.0),


                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Text("Nothing to display yet"),
          ),
          Center(
            child: Text("Nothing to display yet"),
          ),
          Center(
            child: Text("Nothing to display yet"),
          ),
          Center(
            child: Text("Nothing to display yet"),
          ),
        ],
      ),
    );
  }
}
