import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/services/SharedPrederence.dart';
import 'package:agtech_farmer/ui/login/login.dart';
import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
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
                      // Container(
                      //   margin: EdgeInsets.all(20),
                      //   child: Text("Please Choose Language"),
                      // ),
                      Container(
                        margin: EdgeInsets.all(20),
                        height: 70,
                        width: 200,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color.fromRGBO(12, 177, 75, .9),
                          child: Text('English',style: TextStyle(fontSize: 20),),
                          onPressed:() {
                            SharedPreference.saveLanguage("English");
                            Constant.englishyes=true;
                            Navigator.pop(context);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => Login()));
                          }
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        height: 70,
                        width: 200,
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Color.fromRGBO(12, 177, 75, .9),
                            child: Text('ಕನ್ನಡ',style: TextStyle(fontSize: 20),),
                            onPressed:() {
                              SharedPreference.saveLanguage("Kannada");
                              Constant.englishyes=false;
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => Login()));
                            }
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}
