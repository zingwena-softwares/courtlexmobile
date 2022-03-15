import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/screens/add_client.dart';
import 'package:courtlexmobile/screens/clients.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'login.dart';

class ClientDetailsPage extends StatefulWidget {
  final Client client;
  ClientDetailsPage({
  required this.client,
  });

  @override
  _ClientDetailsPageState createState() => _ClientDetailsPageState(
    client:client
      );
}

class _ClientDetailsPageState extends State<ClientDetailsPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  late Client client;

  _ClientDetailsPageState({
    required this.client,

  });

  void _handleDeleteClient(int clientId) async {
    ApiResponse response = await deleteClient(clientId);
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
    _name = new TextEditingController(text: client.name);
    _address = new TextEditingController(text: client.address);
    _city = new TextEditingController(text: client.city);
    _email = new TextEditingController(text: client.email);
    _phone = new TextEditingController(text: client.phone);
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Clients()),),
                  ),
                  Text(
                    'Client Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 80.0,
                  ),
                  InkWell(child: Icon(Icons.share_outlined), onTap: () {}),
                  SizedBox(
                    width: 20.0,
                  ),
                  InkWell(child: Icon(Icons.edit), onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddClient(
                      client: client,
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
                                'Are you sure , you want to delete the Client. '
                                'Records Associated with this Client will not be deleted'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                 _handleDeleteClient(client.id ?? 0);
                                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Clients()), (route) => false);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    width: 20.0,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Text(
                        client.name.toString().substring(0, 1).toUpperCase(),

                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text('${client.name}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
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
              child: Text('CASES'),
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
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Client Name ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _address,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Client Address ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    readOnly: true,
                    controller: _city,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'Case Remarks',
                      labelText: 'Client City ',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //hintText: 'Case Remarks',
                            labelText: 'Phone Number ',
                          ),
                        ),
                      ),
                      Container(
                        height: 55.0,
                        child: ElevatedButton(
                          child: new Text('Call'),
                          onPressed: () async {
                            setState(() {
                              _openUrl('tel:${client.phone}');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _email,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //hintText: 'Case Remarks',
                            labelText: 'Email ',
                          ),
                        ),
                      ),
                      Container(
                        height: 55.0,
                        child: ElevatedButton(
                          child: new Text('Email'),
                          onPressed: () async {
                            setState(() {
                              _openUrl('mailto:${client.email}');
                            });
                          },
                        ),
                      ),
                    ],
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
