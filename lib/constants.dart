import 'package:flutter/material.dart';


//.... Uer SStrings ......

const baseUrl ='https://globtorch.com/myapi/public/api';
const loginUrl =baseUrl + '/login';
const registerUrl = baseUrl+ '/register';
const logoutUrl =baseUrl + '/logout';
const userUrl =baseUrl + '/user';

//... Clients Strings ..../
const saveClientUrl =baseUrl + '/client';
const clientsListUrl =baseUrl + '/clients';
const clientListNamesUrl =baseUrl+ '/clientnames';

//... Cases Strings ..../
const caseListUrl =baseUrl + '/cases';
const saveCaseUrl =baseUrl + '/newcase';
const editCaseUrl =baseUrl + '/case';
const openCaseUrl =baseUrl + '/opencase';
const closeCaseUrl =baseUrl + '/closecase';
const deleteCaseUrl =baseUrl + '/case';

//... Schedule Strings ..../
const saveScheduleUrl =baseUrl + '/newschedule';
const getAllScheduleUrl =baseUrl + '/schedules';
const updateScheduleUrl =baseUrl + '/schedule';
const deleteScheduleUrl =baseUrl + '/schedule';

//... Notes Strings ..../
const saveNoteUrl =baseUrl + '/newnote';
const getAllNotesUrl =baseUrl + '/notes';
const updateNoteUrl =baseUrl + '/note';
const deleteNoteUrl =baseUrl + '/note';


//.......Errors.....//
const serverError ='Server error';
const unauthorized ='Unauthorised';
const somethingwentwrong= 'something went wrong , try again';
const appTitle='CourtLex Diary';

InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black))
  );
}


// button

TextButton kTextButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white),),
    style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
    ),
    onPressed: () => onPressed(),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
          child: Text(label, style:TextStyle(color: Colors.blue)),
          onTap: () => onTap()
      )
    ],
  );
}


// likes and comment btn

Expanded kLikeAndComment (int value, IconData icon, Color color, Function onTap) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color,),
              SizedBox(width:4),
              Text('$value')
            ],
          ),
        ),
      ),
    ),
  );
}
