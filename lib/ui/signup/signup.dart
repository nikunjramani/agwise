import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/constants/custometheme.dart';
import 'package:agtech_farmer/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

enum usertype { Farmer, Agent }

class _SignUpState extends State<SignUp> {
  String token;
  usertype _site = usertype.Farmer;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();

  final GlobalKey<FormFieldState> firstnameFormKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> lastnameFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> mobileFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> repasswordFormKey =
      GlobalKey<FormFieldState>();
  bool _isSubmitButtonEnabled = false;

  Widget buildAppbar(title) {
    return AppBar(
        backgroundColor: const Color(0xFF0CB14B),
        title: Wrap(
          spacing: 10,
          children: [
            Image.asset(
              'assets/images/logo3.png',
              width: 25,
              height: 25,
              color: Colors.white,
            ),
            Text(
              title,
              style: new TextStyle(fontSize: 23),
            ),
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar("SignUp"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: firstname,
                    key: firstnameFormKey,
                    maxLength: 15,
                    maxLengthEnforced: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: buildTextFieldDecoration(
                        Constant.englishyes?"First Name":"ಮೊದಲ ಹೆಸರು", Constant.englishyes?"Enter First Name":"ನಿಮ್ಮ ಮೊದಲ ಹೆಸರನ್ನು ನಮೂದಿಸಿ"),
                    onChanged: (value) {
                      setState(() {
                        _isSubmitButtonEnabled = _isFormValid();
                        firstnameFormKey.currentState.validate();
                      });
                    },
                    validator: (value) {
                      return (value.length >= 2)
                          ? null
                          : Constant.englishyes?'Please Enter Valid First Name':"ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಮೊದಲ ಹೆಸರನ್ನು ನಮೂದಿಸಿ";
                    },
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: lastname,
                    key: lastnameFormKey,
                    maxLength: 15,
                    maxLengthEnforced: true,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: buildTextFieldDecoration(
                        Constant.englishyes?"Last Name":"ಕೊನೆಯ ಹೆಸರು", Constant.englishyes?"Enter Last Name":"ನಿಮ್ಮ ಕೊನೆಯ ಹೆಸರನ್ನು ನಮೂದಿಸಿ"),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: mobile,
                    maxLength: 10,
                    maxLengthEnforced: true,
                    key: mobileFormKey,
                    decoration: buildTextFieldDecoration(
                        Constant.englishyes?"Mobile Number":"ಮೊಬೈಲ್ ನಂಬರ", Constant.englishyes?"Enter Mobile Number":"ನಿಮ್ಮ ಮೊಬೈಲ್ ನಂಬರನ್ನು ನಮೂದಿಸಿರಿ"),
                    onChanged: (value) {
                      setState(() {
                        _isSubmitButtonEnabled = _isFormValid();
                        mobileFormKey.currentState.validate();
                      });
                    },
                    validator: (value) {
                      return (value.length == 10)
                          ? null
                          : Constant.englishyes?'Please Enter Valid Mobile Number':" ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ";
                    },
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black45)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constant.englishyes?"User Type":"ಬಳಕೆದಾರರ ಪ್ರಕಾರ",
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            children: <Widget>[
                              ListTile(
                                title:Text(
                                  Constant.englishyes?'Farmer':'ರೈತ',
                                  style: TextStyle(color: Colors.black45),
                                ),
                                leading: Radio(
                                  value: usertype.Farmer,
                                  groupValue: _site,
                                  onChanged: (usertype value) {
                                    setState(() {
                                      _site = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(Constant.englishyes?'Agent':'ಕಾರ್ಯಕರ್ತ',
                                    style: TextStyle(color: Colors.black45)),
                                leading: Radio(
                                  value: usertype.Agent,
                                  groupValue: _site,
                                  onChanged: (usertype value) {
                                    setState(() {
                                      _site = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: password,
                    key: passwordFormKey,
                    obscureText: true,
                    decoration:
                        buildTextFieldDecoration(Constant.englishyes?"Password":"ಪಾಸ್ವರ್ಡ್", Constant.englishyes?"Enter Password":"ಪಾಸ್ವರ್ಡ್ ನಮೂದಿಸಿ"),
                    onChanged: (value) {
                      setState(() {
                        _isSubmitButtonEnabled = _isFormValid();
                        passwordFormKey.currentState.validate();
                      });
                    },
                    validator: (value) {
                      return (value.length >= 8) ? null : Constant.englishyes?'Minimum of 8 chars is needed':"ಕನಿಷ್ಠ 8 ಅಕ್ಷರಗಳು / ಸಂಖ್ಯೆಗಳು ಇರಬೇಕು";
                    },
                    maxLength: 16,
                    maxLengthEnforced: true,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: repassword,
                    obscureText: true,
                    key: repasswordFormKey,
                    decoration: buildTextFieldDecoration(
                        Constant.englishyes?"Re-enter Password":"ಪಾಸ್‌ವರ್ಡ್ ಅನ್ನು ಮತ್ತೆ ನಮೂದಿಸಿ", Constant.englishyes?"Re-enter Password":"ಪಾಸ್‌ವರ್ಡ್ ಅನ್ನು ಮತ್ತೆ ನಮೂದಿಸಿ"),
                    onChanged: (value) {
                      setState(() {
                        _isSubmitButtonEnabled = _isFormValid();
                        repasswordFormKey.currentState.validate();
                      });
                    },
                    validator: (value) {
                      if (value.length < 8) {
                        return Constant.englishyes?'Minimum of 8 chars is needed':"ಕನಿಷ್ಠ 8 ಅಕ್ಷರಗಳು / ಸಂಖ್ಯೆಗಳು ಇರಬೇಕು";
                      } else if (value != password.text) {
                        return Constant.englishyes?'Both Password Should Match':"ಎರಡೂ  ಪಾಸ್ವರ್ಡ್ ಹೊಂದಿಕೆಯಾಗಬೇಕು";
                      } else {
                        return null;
                      }
                    },
                    maxLength: 16,
                    maxLengthEnforced: true,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                ),
                RaisedButton(
                  color: const Color(0xFF0CB14B),
                  textColor: Colors.white,
                  // color: Color.fromRGBO(12,177,75,.9),
                  child: Text(Constant.englishyes?'Sign Up':"ಸೈನ್ ಅಪ್ ಮಾಡಿ"),
                  onPressed: _isSubmitButtonEnabled
                      ? () {
                          registerUser(
                              firstname.text,
                              lastname.text,
                              _site.toString(),
                              mobile.text,
                              password.text,
                              repassword.text,
                              Constant.firebasetoken);
                        }
                      : null,
                ),
              ],
            )),
      ),
    );
  }

  bool _isFormValid() {
    return ((mobileFormKey.currentState.isValid &&
        passwordFormKey.currentState.isValid &&
        repasswordFormKey.currentState.isValid &&
        firstnameFormKey.currentState.isValid &&
        lastnameFormKey.currentState.isValid &&
        passwordFormKey.currentState.isValid));
  }

  void registerUser(
      String firstname,
      String lastname,
      String usertype,
      String mobile,
      String password,
      String repassword,
      String device_id) async {

      Map<String, String> userrecord = new Map();
      userrecord["first_name"] = firstname;
      userrecord["last_name"] = lastname;
      userrecord["password"] = password;
      userrecord["usertype"] = usertype;
      userrecord["device_id"] = device_id;
      userrecord["mobile"] = mobile;
      Uri url = Uri.parse(Constant.serverurl+"register/");
      var response = await http.post(url, body: userrecord);
      var data = jsonDecode(response.body);
      if (data["success"] == "True") {
        showToast(Constant.englishyes?"Registration Successful":"ನೋಂದಣಿ ಯಶಸ್ವಿಯಾಗಿದೆ");
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      } else {
        showToast(Constant.englishyes?"User with this mobile number already exits!":"ಈ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯ ಬಳಕೆದಾರರು ಈಗಾಗಲೇ ನಿರ್ಗಮಿಸಿದ್ದಾರೆ!");
      }
  }


  showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  buildTextFieldDecoration(String label, String hint) {
    return InputDecoration(
      focusedBorder: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.black45)),
      border: new OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.black45),
      labelText: label,
      hintText: hint,
    );
  }
}
