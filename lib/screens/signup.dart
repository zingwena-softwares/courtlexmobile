import 'package:courtlexmobile/components/background.dart';
import 'package:courtlexmobile/constants.dart';
import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/user.dart';
import 'package:courtlexmobile/screens/home.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController lawfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password_confirmController = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, surnameController.text, emailController.text,phoneController.text,addressController.text,lawfirmController.text, passwordController.text,password_confirmController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      print(response.error);
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePage(title: appTitle, user: user,)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (val) => val!.isEmpty ? 'Name cannot be Empty' : null,
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (val) => val!.isEmpty ? 'Surname cannot be Empty' : null,
                    keyboardType: TextInputType.name,
                    controller: surnameController,
                    decoration: InputDecoration(labelText: "Surname"),
                  ),
                ),

                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: phoneController,
                    validator: (val) => val!.isEmpty ? 'Phone Number cannot be Empty' : null,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Mobile Number"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: emailController,
                    validator: (val) => val!.isEmpty ? 'Email cannot be Empty ' : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: addressController,
                    validator: (val) => val!.isEmpty ? 'Address cannot be Empty' : null,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(labelText: "Address"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: lawfirmController,
                    validator: (val) => val!.isEmpty ? 'Firm cannot be Empty' : null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Law Firm"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (val) => val!.isEmpty ? 'Password cannot be Empty' : null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: password_confirmController,
                    validator: (val) => val != passwordController.text ? 'Password does not match' : null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                loading ?
                Center(child: CircularProgressIndicator()):
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "SIGN UP",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()))
                    },
                    child: Text(
                      "Already Have an Account? Sign in",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
