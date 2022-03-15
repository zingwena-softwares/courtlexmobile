import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/screens/clients.dart';
import 'package:courtlexmobile/services/client_service.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'login.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key? key,  this.client,}) : super(key: key);
  final Client? client;
  @override
  _AddClientState createState() => _AddClientState();

}

class _AddClientState extends State<AddClient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  void _saveClient() async {
    ApiResponse response = await saveClient(_nameController.text, _addressController.text,_cityController.text,_phoneController.text, _emailController.text);
    if (response.data!= null){
      //Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Clients()), (route) => false);

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

  // edit post
  void _editClient(int clientId) async {
    ApiResponse response = await editClient(clientId,_nameController.text, _addressController.text, _cityController.text,_phoneController.text, _emailController.text);
    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Clients()), (route) => false);
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
  if(widget.client != null){
    _nameController.text = widget.client!.name!;
    _addressController.text = widget.client!.address!;
    _cityController.text = widget.client!.city!;
    _phoneController.text = widget.client!.phone!;
    _emailController.text = widget.client!.email!;
  }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.client!=null? Text("Edit Client"):Text("Add Client"),
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
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Client Full Name",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Client Address",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.name,
                controller: _cityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Client City",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Client Phone",

                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Client Email",
                ),
              ),
              SizedBox(height: 16.0),

              SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed:(){
                    if (widget.client == null) {
                      _saveClient();
                    } else {
                      _editClient(widget.client!.id ?? 0);
                    }
                  },
                  // _saveClient,
                  child: Text(
                    'Save the Client',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
