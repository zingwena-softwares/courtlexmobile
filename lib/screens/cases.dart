import 'package:courtlexmobile/constants.dart';
import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/case.dart';
import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/models/user.dart';
import 'package:courtlexmobile/screens/add_case.dart';
import 'package:courtlexmobile/services/case_service.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'case_details.dart';
import 'home.dart';
import 'login.dart';

class Cases extends StatefulWidget {
  const Cases({
    Key? key,
  }) : super(key: key);

  @override
  _CasesState createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  List<dynamic> _caseList = [];
   List<Client> _clientsNames = [];

  bool _loading = true;
  int userId = 0;
  int _editCaseId = 0;

  // Get cases
  Future<void> _getCases() async {
    userId = await getUserId();
    ApiResponse response = await getCases();
    if (response.error == null) {
      setState(() {
        _caseList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future<List<Client>> _getClientsNames() async {
    final clients = await getClientsNames();
    if (_clientsNames.length == 0)
      _clientsNames.addAll(clients);
    return _clientsNames.toList();
  }

  @override
  void initState() {
    _getCases();
    _getClientsNames();
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
          title: Text("Cases"),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return _getCases();
                      },
                      child: ListView.builder(
                          itemCount: _caseList.length,
                          itemBuilder: (BuildContext context, int index) {
                            ClientCase clientcase = _caseList[index];
                            return Card(
                              elevation: 5,
                              child: Container(
                                  //padding: const EdgeInsets.all(12.0),
                                  child: ListTile(
                                isThreeLine: false,
                                title: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${clientcase.case_title}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '(${clientcase.court_city})',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                   subtitle: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${clientcase.client_name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,

                                  ),
                                ),
                              ),
                              /*Text(
                                '${clientcase.court_city}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),*/
                            ],
                          ),
                                trailing: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 100.0,
                                      color: Colors.blue,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${clientcase.nextcourt_date}',
                                            //'${clientcase.nextcourt_date.toString().substring(0, 10)}',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      width: 100.0,
                                      color: clientcase.case_status == "OPEN"
                                          ? Colors.red
                                          : Colors.green,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${clientcase.case_status}',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                   Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CaseDetails(
                                    cases:clientcase,
                                  )),
                            );
                                },
                              )),
                            );
                          }),
                    ),
                  ),
                ],
              ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            onPressed: () {
             List<String?> list = _clientsNames.map((e) => e.name).toList();
              List<String> filter(List<String?> input) {
                input.removeWhere((e) => e == null);
                return List<String>.from(input);
              }
              List<String> filteredList = filter(list); // New list
              Navigator.of(context)
                  .pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => AddCase(
                        clients: filteredList,
                      ),
                      fullscreenDialog: true,
                    ),
                  )
                  .then((_) => setState(() {}));
            },

            child: FaIcon(FontAwesomeIcons.plus),
          ),
        ]));
  }
}
