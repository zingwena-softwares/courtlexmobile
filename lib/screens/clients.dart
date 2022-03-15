import 'package:courtlexmobile/constants.dart';
import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/models/user.dart';
import 'package:courtlexmobile/screens/home.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'add_client.dart';
import 'client_details.dart';
import 'login.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  List<dynamic> _clientsList = [];
  int userId = 0;
  bool _loading = true;


  Future<void> retrieveClients() async {
    userId = await getUserId();
    ApiResponse response = await getClients();
   // print(response.error);
    if(response.error == null){
      setState(() {
        _clientsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
    return null;
  }

  @override
  void initState() {
    retrieveClients();
    super.initState();
  }
 @override
  Widget build(BuildContext context) {
    return _loading ? Container(color: Colors.white,
        child: Center(child:CircularProgressIndicator())) :
    RefreshIndicator(
      onRefresh: () {
        return retrieveClients();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              ApiResponse response = await getUserDetails();
              User user=response.data as User;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(title: appTitle,user: user,)),
              );
            },
          ),
          title: Text("Clients"),
        ),
        body: ListView.builder(
            itemCount: _clientsList.length,
            itemBuilder: (BuildContext context, int index){
              Client client = _clientsList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child:InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ClientDetailsPage(
                            client:client,
                          )),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${client.name}'.toString().substring(0, 1).toUpperCase(),
                              //clients.id.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${client.name}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                //Text(clients.address),
                                //SizedBox(height: 4.0),
                                //Text(clients.city),
                                SizedBox(height: 4.0),
                                Text( '${client.phone}'),
                                SizedBox(height: 4.0),
                                Text( '${client.email}'),
                                //SizedBox(height: 4.0),
                                //Text(clients.remarks),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
            }
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (_) => AddClient(),
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
      ),
    );
  }
}
