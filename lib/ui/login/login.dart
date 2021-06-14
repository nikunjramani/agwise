import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/constants/custometheme.dart';
import 'package:agtech_farmer/models/farmer.dart';
import 'package:agtech_farmer/services/SharedPrederence.dart';
import 'package:agtech_farmer/ui/chatscreen/chatscreen.dart';
import 'package:agtech_farmer/ui/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormFieldState> numberFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormKey = GlobalKey<FormFieldState>();
  bool _isSubmitButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(50),
                    // alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/Agtech_logo.jpg',
                      width: 300,
                      height: 300,
                      // color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black45)),
                        labelStyle: TextStyle(color: Colors.black45),
                        labelText: Constant.englishyes?'Mobile Number':'ಸಂಪರ್ಕ ಸಂಖ್ಯೆ',
                        hintText: Constant.englishyes?'Enter Mobile Number':'ಸಂಪರ್ಕ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ',
                      ),
                      maxLength: 10,
                      maxLengthEnforced: true,
                      key: numberFormKey,
                      onChanged: (value) {
                        setState(() {
                          _isSubmitButtonEnabled = _isFormValid();
                          numberFormKey.currentState.validate();
                        });
                      },
                      validator: (value) {
                        return (value.length == 10)
                            ? null
                            : Constant.englishyes?'Enter Valid Mobile Number':'ಮಾನ್ಯ ಸಂಪರ್ಕ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ ';
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(10),
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black45)),
                        labelStyle: TextStyle(color: Colors.black45),
                        labelText: Constant.englishyes?'Password':'ಪಾಸ್ವರ್ಡ್',
                        hintText: Constant.englishyes?'Enter Password':'ಪಾಸ್ವರ್ಡ್ ನಮೂದಿಸಿ',
                      ),
                      key: passwordFormKey,
                      onChanged: (value) {
                        setState(() {
                          _isSubmitButtonEnabled = _isFormValid();
                          passwordFormKey.currentState.validate();
                        });
                      },
                      validator: (value) {
                        return (value.length >= 8)
                            ? null
                            : Constant.englishyes?'Minimum of 8 chars is needed':'ಕನಿಷ್ಠ 8 ಅಕ್ಷರಗಳು / ಸಂಖ್ಯೆಗಳು ಇರಬೇಕು';
                      },
                      maxLength: 16,
                      maxLengthEnforced: true,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(16),
                      ],
                    ),
                  ),
                  // FlatButton(
                  //   onPressed: (){
                  //     //TODO FORGOT PASSWORD SCREEN GOES HERE
                  //   },
                  //   child: Text(
                  //     'Forgot Password',
                  //     style: TextStyle(color: Colors.black54, fontSize: 15),
                  //   ),
                  // ),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Color.fromRGBO(12, 177, 75, .9),
                    child: Text(Constant.englishyes?'Sign In':'ಸೈನ್-ಇನ್ ಮಾಡಿ '),
                    onPressed: _isSubmitButtonEnabled
                        ? () {
                            loginUser(
                                nameController.text, passwordController.text);
                          }
                        : null,
                  ),
                  FlatButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      Constant.englishyes?"Don't have a account? Sign Up":'ಖಾತೆ ಇಲ್ಲವೇ? ಹೊಸ ಖಾತೆಯನ್ನು ಇಲ್ಲಿ ರಚಿಸಿ',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                ],
              )),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isFormValid() {
    return ((numberFormKey.currentState.isValid &&
        passwordFormKey.currentState.isValid));
  }

  void loginUser(String number, String password) async {
    final String token1 = Constant.firebasetoken;
    Map<String, String> userrecord = new Map();
    userrecord["mobile"] = number;
    userrecord["password"] = password;
    userrecord["device_id"] = token1;

    Uri url = Uri.parse(Constant.serverurl+"login/");
    var response = await http.post(url, body: userrecord);
    var userresponse = jsonDecode(utf8.decode(response.bodyBytes));
    print(userresponse);
    if (userresponse.containsKey("non_field_errors")) {
      showToast(Constant.englishyes?"Invaild Login Credential":"ಲಾಗಿನ್ ರುಜುವಾತುಗಳನ್ನು ಆಕ್ರಮಿಸಿ");
    } else if (userresponse.containsKey("password")) {
      showToast(Constant.englishyes?"Invaild Login Credential":"ಲಾಗಿನ್ ರುಜುವಾತುಗಳನ್ನು ಆಕ್ರಮಿಸಿ");
    } else if (userresponse.containsKey("token")) {
      showToast(Constant.englishyes?"Login Successful":"ಲಾಗಿನ್ ಯಶಸ್ವಿಯಾಗಿದೆ");
      SharedPreference.saveNumber(userresponse["mobile"]);
      SharedPreference.saveUserToken(userresponse["token"]);
      var firstname = userresponse["fname"];
      SharedPreference.savefarmerId(userresponse["_id"]);
      SharedPreference.saveIsUserLogin(true);
      SharedPreference.saveFarmerName(getCapitalizeString(firstname));
      Constant.number = userresponse["mobile"];
      Constant.farmername = getCapitalizeString(firstname);
      print(Constant.farmername);
      Constant.farmerid = userresponse["_id"];
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ChatScreen()));
    } else {
      showToast(Constant.englishyes?"Invalid Login Credential":"ಲಾಗಿನ್ ರುಜುವಾತುಗಳನ್ನು ಆಕ್ರಮಿಸಿ");
    }
  }

  String getCapitalizeString(String str) {
    if (str.length <= 1) {
      return str.toUpperCase();
    }
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }

  showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
