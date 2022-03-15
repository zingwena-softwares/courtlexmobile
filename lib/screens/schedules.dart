import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/schedule.dart';
import 'package:courtlexmobile/models/user.dart';
import 'package:courtlexmobile/screens/add_schedule.dart';
import 'package:courtlexmobile/screens/schedule_details.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/schedule_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'home.dart';
import 'login.dart';

class Schedules extends StatefulWidget {
  const Schedules({Key? key}) : super(key: key);

  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  List<dynamic> _schedulesList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrieveSchedules() async {
    userId = await getUserId();
    ApiResponse response = await getAllSchedules();
    // print(response.error);
    if (response.error == null) {
      setState(() {
        _schedulesList = response.data as List<dynamic>;
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
    retrieveSchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? Container(color: Colors.white,
        child: Center(child:CircularProgressIndicator())) : RefreshIndicator(
        onRefresh: () {
          return retrieveSchedules();
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
            title: Text("Schedules"),
          ),

          body: ListView.builder(
              itemCount: _schedulesList.length,
              itemBuilder: (BuildContext context, int index) {
                Schedule schedule = _schedulesList[index];
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
                                '${schedule.type}',
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
                              '(${schedule.title})',
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
                                '${schedule.date}',
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
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScheduleDetails(
                                  schedule:schedule,
                                )),
                          );
                        },
                      )),
                );
              }),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (_) => AddScedule(),
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
        ));
  }
}
