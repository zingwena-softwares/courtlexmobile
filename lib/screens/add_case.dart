import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/case.dart';
import 'package:courtlexmobile/screens/cases.dart';
import 'package:courtlexmobile/services/case_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'login.dart';

class AddCase extends StatefulWidget {
  const AddCase({Key? key, this.clientId, this.clients, this.cases}) : super(key: key);
  final int? clientId;
  final List<String>? clients;
  final ClientCase? cases;

  @override
  _AddCaseState createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  late final _tabController = TabController(length: 3, vsync: this);
 //bool priceupdate_value = false;
  final List<String> statusList = ["OPEN", "CLOSED"];
  final List<String> subjectList = [
    "Criminal",
    "Civil",
    "Labor",
    "Commercial",
    "Conveyancing",
    "Notary",
    "Family",
    "Estates"
  ];

  //case basic details controllers
  String case_status = '';
  String case_subject = '';
  final TextEditingController _caseTitle = TextEditingController();
  final TextEditingController _caseNumber = TextEditingController();

  //opponent details controllers
  final TextEditingController _respLawyerName = TextEditingController();
  final TextEditingController _respLawyerPhone = TextEditingController();
  final TextEditingController _respLawyerEmail = TextEditingController();
  TextEditingController _respLawyerFirm = TextEditingController();
  final TextEditingController _respLawFirmCity = TextEditingController();
  final TextEditingController _respLawFirmAddress = TextEditingController();

  //court details controllers
  final TextEditingController _courtName = TextEditingController();
  final TextEditingController _courtCity = TextEditingController();
  TextEditingController _courtDate = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _addedBy = TextEditingController();

  String selected_client = '';
  bool _loading = true;
  DateTime selectedDate = DateTime.now();

  void _createCase() async {
    ApiResponse response = await createCase(
        case_status,
        _caseTitle.text,
        selected_client,
        case_subject,
        _caseNumber.text,
        _respLawyerName.text,
        _respLawyerPhone.text,
        _respLawyerEmail.text,
        _respLawyerFirm.text,
        _respLawFirmCity.text,
        _respLawFirmAddress.text,
        _courtName.text,
        _courtCity.text,
        _courtDate.text,
        _notes.text,
        _addedBy.text);
    if (response.data!= null){
      //Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Cases()), (route) => false);

    }
    else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
// edit post
  void _editCase(int caseId) async {
    ApiResponse response = await editCase(
      caseId,
        case_status,
        _caseTitle.text,
        selected_client,
        case_subject,
        _caseNumber.text,
        _respLawyerName.text,
        _respLawyerPhone.text,
        _respLawyerEmail.text,
        _respLawyerFirm.text,
        _respLawFirmCity.text,
        _respLawFirmAddress.text,
        _courtName.text,
        _courtCity.text,
        _courtDate.text,
        _notes.text,
        _addedBy.text
    );
    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Cases()), (route) => false);
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
    if(widget.cases != null){
      case_status=widget.cases!.case_status!;
    _caseTitle.text=widget.cases!.case_title!;
    selected_client=widget.cases!.client_name!;
    case_subject=widget.cases!.case_subject!;
    _caseNumber.text=widget.cases!.case_number!;
    _respLawyerName.text=widget.cases!.resplawyer_name!;
    _respLawyerPhone.text=widget.cases!.resplawyer_phone!;
    _respLawyerEmail.text=widget.cases!.resplawyer_email!;
    _respLawyerFirm.text=widget.cases!.resplawyer_lawfirmname!;
    _respLawFirmCity.text=widget.cases!.resplawyer_lawfirmcity!;
    _respLawFirmAddress.text=widget.cases!.resplawyer_lawfirmaddress!;
    _courtName.text=widget.cases!.court_name!;
    _courtCity.text=widget.cases!.court_city!;
    _courtDate.text=widget.cases!.nextcourt_date!;
    _notes.text=widget.cases!.notes!;
    _addedBy.text=widget.cases!.added_by!;
    }
    // TODO: implement initState
    super.initState();
    _courtDate = new TextEditingController(
        text: selectedDate.toString().substring(0, 10));
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        _courtDate.text = selected.toString().substring(0, 10);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Cases()),
            );
          },
        ),
        title:  widget.cases!=null? Text("Edit Cases"):Text("Add New Case"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          unselectedLabelColor: Colors.white.withOpacity(0.3),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Creates border
              color: Colors.grey),
          tabs: [
            Row(
              children: [
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  alignment: Alignment.center,
                  child: Text(
                    "1",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("Basic Details"),
                Text("--------"),
              ],
            ),
            Row(
              children: [
                Text("--------"),
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  alignment: Alignment.center,
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("Respondent Details"),
              ],
            ),
            Row(
              children: [
                Text("--------"),
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  alignment: Alignment.center,
                  child: Text(
                    "4",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("Court Details"),
              ],
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.0),
                  DropdownSearch<String>(
                    popupSafeArea: PopupSafeAreaProps() ,
                    mode: Mode.MENU,
                    showSelectedItems: true,
                    items: statusList,
                    label: "Select Case Status",
                    hint: "Select Case Status",
                    onChanged: (String? newValue) {
                      setState(() {
                        case_status = newValue!;
                      });
                    },
                    selectedItem: case_status,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Case Status is Required';
                      }
                    },
                  ),

                  SizedBox(height: 16.0),
                  TextFormField(
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

                  FutureBuilder<List<String?>>(
                      //future: _getClients(),
                      builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading clients...");
                    }
                    return DropdownSearch<String>(
                      maxHeight: 500,
                      mode: Mode.MENU,
                      showSelectedItems: true,
                      items: widget.clients,
                      label: "Select Client",
                      hint: "Select Client",
                      //popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (newValue) {
                        setState(() {
                          selected_client = newValue!;
                        });
                      },
                      selectedItem: selected_client,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Client is Required';
                        }
                      },
                    );
                  }),
                  SizedBox(height: 16.0),
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItems: true,
                    items: subjectList,
                    label: "Select Case Subject",
                    hint: "Select Case Subject",
                    onChanged: (String? newValue) {
                      setState(() {
                        case_subject = newValue!;
                      });
                    },
                    selectedItem: case_subject,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Case Subject is Required';
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _caseNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Case Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Case Number is Required';
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()){
                            _tabController.index = 1;
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Icon(Icons.navigate_next_outlined)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Form(
            key: _formKey1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _respLawyerName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Respondent Lawyer Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Respondent Lawyer Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _respLawyerPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Respondent Lawyer Phone',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Respondent Lawyer Phone';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _respLawyerEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Respondent Lawyer Email',
                    ),
                    validator:(value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _respLawyerFirm,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Respondent Lawyer LawFirm',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Respondent Lawyer LawFirm';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    controller: _respLawFirmCity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Respondent LawFirm City',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Respondent LawFirm City';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    controller: _respLawFirmAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Respondent LawFirm Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Respondent LawFirm Address';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _tabController.index = 0;
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey1.currentState!.validate()){
                            _tabController.index = 2;
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Icon(Icons.navigate_next_outlined)
                          ],
                        ),
                      ),
                    ],
                  )
                  /*  SizedBox(
                    height: 45.0,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: Text(
                        'Save the Client',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _courtName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Court Name',
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Enter Court Name';
                    }
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _courtCity,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Court City',
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Enter Court City';
                    }
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  },
                  controller: _courtDate,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Next Court Date',
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Enter Next Court Date';
                    }
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _notes,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Notes',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _addedBy,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Added By',
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Added By is required';
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _tabController.index = 1;
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _createCase();

                      },
                      child: Row(
                        children: [
                          Text(
                            'Complete',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Icon(Icons.done)
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ]),
    );
  }
}
