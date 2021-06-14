import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/main.dart';
import 'package:agtech_farmer/models/ExpandedCard.dart';
import 'package:agtech_farmer/models/POP.dart';
import 'package:agtech_farmer/ui/map/viewmap.dart';
import 'package:agtech_farmer/ui/videoplayer/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:latlong/latlong.dart';


class ChatWidgets extends StatefulWidget {
  String type,message;
  bool isSendByMe;
  Future<void> Function(String msg, bool sendornot, String dummymessage) reponses;
  void Function(int id, String message, bool isSendByMe, String type) addChatToChatList;

  ChatWidgets(this.type, this.message, this.isSendByMe, this.reponses,this.addChatToChatList);
  @override
  _ChatWidgetsState createState() => _ChatWidgetsState(type, message, isSendByMe, reponses,addChatToChatList);
}

class _ChatWidgetsState extends State<ChatWidgets> {
  String type,message;
  List<TextEditingController> controllers=new List<TextEditingController>();

  TextEditingController clayController=new TextEditingController();
  TextEditingController sandController=new TextEditingController();
  TextEditingController siltController=new TextEditingController();
  TextEditingController nController=new TextEditingController();
  TextEditingController pController=new TextEditingController();
  TextEditingController kController=new TextEditingController();
  TextEditingController ecController=new TextEditingController();
  TextEditingController ocController=new TextEditingController();
  TextEditingController phController=new TextEditingController();
  final GlobalKey<FormFieldState> clayFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> sandFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> siltFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> nFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> pFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> kFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> ecFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> ocFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> phFormKey = GlobalKey<FormFieldState>();
  bool _isSubmitPButtonEnabled = false;
  bool _isSubmitNButtonEnabled = false;

  bool isSendByMe;
  Future<void> Function(String msg, bool sendornot, String dummymessage) reponses;
  void Function(int id, String message, bool isSendByMe, String type) addChatToChatList;

  _ChatWidgetsState(this.type, this.message, this.isSendByMe, this.reponses,this.addChatToChatList);

  VideoPlayerController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    if(type == "message"){
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: 22, vertical: 14),
          decoration: buildBoxDecoration(isSendByMe),
          child: Container(
            child: Text(
              message,
              style: buildTextStyle(isSendByMe),
            ),
          ));
    }
    else if(type == "image"){
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: 5, vertical: 5),
        decoration: buildBoxDecoration(isSendByMe),
        child: Image.file(
          File(message.toString()),
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      );
    }
    // else if(type == "buttons"){
    //   List<Button1> buttons = [];
    //   List list1=jsonDecode((message.toString().replaceAll("'", '"')));
    //   list1.forEach((element) {
    //     buttons.add(new Button1(element["name"], element["intent"], jsonEncode(element["response"])));
    //   });
    //   return Container(
    //     height: 50,
    //     child: buttons != null
    //         ?  ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       shrinkWrap: true,
    //       itemCount: buttons.length,
    //       itemBuilder: (context, index) {
    //         return Container(
    //           margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //           child: FlatButton(
    //             // color:Color(0xFFEC800E),
    //             color:Color(0xFF0CB14B),
    //
    //             child: Container(
    //               height: 50,
    //               alignment: Alignment.center,
    //               padding: EdgeInsets.all(5),
    //               // decoration: buildButtonDecoration(isSendByMe),
    //               child: Text(
    //                 buttons[index].name,
    //                 style: buildButtonTextStyle(isSendByMe),
    //               ),
    //             ),
    //             textColor: Colors.white,
    //             onPressed: () {
    //               if(buttons[index].intent=="fd_irrigation_system" || buttons[index].intent=="fd_soil_physical_report_value" || buttons[index].intent=="fd_soil_nuteriant_report_value"|| buttons[index].intent=="planting_date_crop_selection") {
    //                 reponses("/"+buttons[index].intent+buttons[index].response, false,buttons[index].name);
    //               }else{
    //                 reponses("/"+buttons[index].intent, false,buttons[index].name);
    //               }
    //             },
    //           ),
    //         );
    //       },
    //     )
    //         : Container(),
    //
    //   );
    // }
    else if(type == "actionbutton"){
      List<Button1> buttons = [];
      List list1=jsonDecode((message.toString().replaceAll("'", '"')));
      list1.forEach((element) {
        buttons.add(new Button1(element["name"], element["intent"], jsonEncode(element["response"])));
      });
      Constant.intent="/"+buttons[0].intent.toString();
      String intentresponse="/"+buttons[1].intent.toString()+buttons[1].response.toString();
      return Container(
        height: 50,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: FlatButton(
                color:Color(0xFF0CB14B),

                onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewMap(reponses,addChatToChatList)))
              },
                    child:Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      // decoration: buildButtonDecoration(isSendByMe),
                      child: Text(
                        buttons[0].name,
                        style: buildButtonTextStyle(isSendByMe),
                      ),
                    ),
      ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: FlatButton(
                color:Color(0xFF0CB14B),

                onPressed: () => {
                  reponses(intentresponse, false,buttons[1].name),
                },
                child:Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  // decoration: buildButtonDecoration(isSendByMe),
                  child: Text(
                    buttons[1].name,
                    style: buildButtonTextStyle(isSendByMe),
                  ),
                ),
              ),
            ),
          ],
        ));
    }
    else if(type == "video"){
      // _controller = VideoPlayerController.asset(
      //     'assets/videos/Record_2021-05-10-15-07-50.mp4')
      //   ..initialize().then((_) {
      //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //   });
      return GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayer1()));

        },
        child: Container(
            width: 250,
            height: 250,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: buildBoxDecoration(isSendByMe),
            child: Stack(
              children: [

                // VideoPlayer(_controller),
                GestureDetector(

                  child: Container(
                      alignment: Alignment.center,
                      child: Icon(Icons.play_arrow,size: 35,)
                  ),
                ),
              ],
            )
        ),
      );
    }
    else if(type == "map"){
      List<String> latlong=message.split('&');
      return Container(
          width: 250,
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: buildBoxDecoration(isSendByMe),
          child: FlutterMap(
            options: new MapOptions(
              // debugMultiFingerGestureWinner: true,
              //   enableMultiFingerGestureRace: true,
                plugins: [
                ],
                center: LatLng(double.parse(latlong[0]),double.parse(latlong[1])),
                minZoom: 8.0,
                onTap: (latlng) {

                }),
            layers: [
              new TileLayerOptions(
                // zoomReverse: true,
                urlTemplate:
                "https://api.mapbox.com/styles/v1/nikunjramani7624/ckoo6i07a9qxx18mu4tevj7u8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmlrdW5qcmFtYW5pNzYyNCIsImEiOiJja29iN2YxdmYwamxyMnVveTZkdXdzM3lkIn0.sruhXMb6uLQT563JVxA8Sg",
                additionalOptions: {
                  'accessToken':
                  '*pk.eyJ1IjoibmlrdW5qcmFtYW5pNzYyNCIsImEiOiJja29iN2YxdmYwamxyMnVveTZkdXdzM3lkIn0.sruhXMb6uLQT563JVxA8Sg',
                  'id': 'mapbox.mapbox-streets-v7'
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(double.parse(latlong[0]),double.parse(latlong[1])),
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.pin_drop,
                        color: const Color(0xFF0CB14B),
                        size: 50,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
      );
    }
    else if(type == "buttons"){
      // List<Button1> buttons = [];
      List list1=jsonDecode((message.toString().replaceAll("'", '"')));
      int _fields = list1.length;
      int _fields1 = list1.length%2==0?(list1.length/2).round():(list1.length/2).round() - 1;
      int index=0;
      // list1.forEach((element) {
      //   buttons.add(new Button1(element["name"], element["intent"], jsonEncode(element["response"])));
      // });
      return Container(
        child: Column(
          children: [
            for (int index1 = 1; index1 <= _fields1; index1++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int index2 = 0; index2 < 2; index2++,index++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: FlatButton(
                          // color:Color(0xFFEC800E),
                          color:Color(0xFF0CB14B),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            // decoration: buildButtonDecoration(isSendByMe),
                            child: Text(
                              list1[index2]["name"],
                              style: buildButtonTextStyle(isSendByMe),
                            ),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            if(list1[index2]["intent"]=="fd_irrigation_system" || list1[index2]["intent"]=="fd_soil_physical_report_value" || list1[index2]["intent"]=="fd_soil_nuteriant_report_value"|| list1[index2]["intent"]=="planting_date_crop_selection") {
                              reponses("/"+list1[index2]["intent"]+jsonEncode(list1[index2]["response"]), false,list1[index2]["name"]);
                            }else{
                              reponses("/"+list1[index2]["intent"], false,list1[index2]["name"]);
                            }
                          },
                      ),
                ),
                    ),
                ],
              ),
            if(_fields%2 !=0)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: FlatButton(
                  color:Color(0xFF0CB14B),

                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      list1[_fields-1]["name"],
                      style: buildButtonTextStyle(isSendByMe),
                    ),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    if(list1[_fields-1]["intent"]=="fd_irrigation_system" || list1[_fields-1]["intent"]=="fd_soil_physical_report_value" || list1[_fields1-1]["intent"]=="fd_soil_nuteriant_report_value"|| list1[_fields1-1]["intent"]=="planting_date_crop_selection") {
                      reponses("/"+list1[_fields-1]["intent"]+jsonEncode(list1[_fields-1]["response"]), false,list1[_fields-1]["name"]);
                    }else{
                      reponses("/"+list1[_fields-1]["intent"], false,list1[_fields-1]["name"]);
                    }
                  },
                ),
              ),

          ],
        ),
      );
    }
    else if(type == "forms"){
      var textFieldList =jsonDecode(message);
      int _fields = textFieldList.length;
      int _fields1 = textFieldList.length%2==0?(textFieldList.length/2).round():(textFieldList.length/2).round() - 1;
      int index=0;
      controllers = List.generate(_fields, (i) => TextEditingController());
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: buildButtonDecoration(isSendByMe),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int index1 = 1; index1 <= _fields1; index1++)
              Row(
                children: [
                  for (int index2 = 0; index2 < 2; index2++,index++)
                      Container(
                      width: 130,
                      // height: 50,
                      margin: EdgeInsets.only(right: 10,bottom: 5),
                      child: TextField(
                        controller: controllers[index],
                        style: TextStyle(color: Colors.black54),
                        decoration: InputDecoration(
                            labelText: textFieldList[index],
                            hintStyle: TextStyle(color: Colors.black54),
                            // hintText: textFieldList[index],
                          labelStyle: TextStyle(color: const Color(0xFF0CB14B)),
                          enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
                          focusedBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
                          border:  new OutlineInputBorder(
                              borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
                        ),
                        keyboardType: TextInputType.number,
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
                      ),
                    ),
                ],
              ),
            if(_fields%2 !=0)
              Container(
                width: 130,
                // height: 50,
                child: TextField(
                  maxLines: null,
                  maxLengthEnforced: false,
                  // textInputAction: TextInputAction.send,
                  controller: controllers[_fields-1],
                  style: TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                      labelText: textFieldList[_fields-1],
                      hintStyle: TextStyle(color: Colors.black54),
                      // hintText: textFieldList[index],
                    labelStyle: TextStyle(color: const Color(0xFF0CB14B)),
                    enabledBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
                    focusedBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
                    border:  new OutlineInputBorder(
                        borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
                  ),
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                ),
              ),
            RaisedButton(
                color: const Color(0xFF0CB14B),
                child: Text(Constant.englishyes?"Submit":"ಸಲ್ಲಿಸು"),
                onPressed: (){
                  // if(controllers[1].text.isEmpty){
                  //
                  // }
                  bool check=false;
                String str1="";
                  Map<String,String> mapresponse=new Map();
                  for(int i=0;i<_fields;i++){
                    String test=Constant.formsslot[i];
                    mapresponse[test]=controllers[i].text;
                    str1+=textFieldList[i]+" = "+controllers[i].text+" ";
                  }
                  reponses("/"+Constant.intent+jsonEncode(mapresponse), false,str1);
                  Constant.intent="";
                }
            )
          ],
        ),
      );
    }
    else if(type == "soilphysical"){
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: buildButtonDecoration(isSendByMe),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                          width: 130,
                          // height: 50,
                          margin: EdgeInsets.only(right: 10,bottom: 5),
                          child: TextFormField(
                            onEditingComplete: () => node.nextFocus(),
                            controller: clayController,
                            style: TextStyle(color: Colors.black54),
                            decoration: buildTextFieldDecoration(Constant.englishyes?"Clay":"ಜೇಡಿಮಣ್ಣು"),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            key: clayFormKey,
                            onChanged: (value) {
                              setState(() {
                                _isSubmitPButtonEnabled = _isSoilPValid();
                              });
                            },
                            inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],
                          ),
                        ),
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    key: sandFormKey,
                    onEditingComplete: () => node.nextFocus(),
                    controller: sandController,
                    style: TextStyle(color: Colors.black54),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"Sand":"ಮರಳು"),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],
                    onChanged: (value) {
                      setState(() {
                        _isSubmitPButtonEnabled = _isSoilPValid();
                      });
                    },
                  ),
                ),

              ],
            ),
            Container(
              width: 130,
              // height: 50,
              margin: EdgeInsets.only(right: 10,bottom: 5),
              child: TextFormField(
                controller: siltController,
                key: siltFormKey,
                onEditingComplete: () => node.nextFocus(),
                style: TextStyle(color: Colors.black54),
                decoration: buildTextFieldDecoration(Constant.englishyes?"Silt":"ಹೂಳು"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],
                onChanged: (value) {
                  setState(() {
                    _isSubmitPButtonEnabled = _isSoilPValid();
                  });
                },
              ),
            ),
            RaisedButton(
                color: const Color(0xFF0CB14B),
                child: Text(Constant.englishyes?"Submit":"ಸಲ್ಲಿಸು",style: TextStyle(color: Colors.white),),
                onPressed: _isSubmitPButtonEnabled?(){
                  Map<String,String> mapresponse=new Map();
                  String enstr1="",knstr1="";
                  // if(sandController.text.length==0 ||clayController.text.length==0 ||siltController.text.length==0 ){
                  //
                  // }else{
                    mapresponse["Clay"]=clayController.text;
                    mapresponse["Sand"]=sandController.text;
                    mapresponse["Silt"]=siltController.text;
                    enstr1 ="ಜೇಡಿಮಣ್ಣು = "+clayController.text+" %"+" ಮರಳು = "+sandController.text+" %"+" ಹೂಳು = "+siltController.text+" %";
                    enstr1 ="Clay = "+clayController.text+" %"+" Sand = "+sandController.text+" %"+" Silt = "+siltController.text+" %";
                    reponses("/"+Constant.intent+jsonEncode(mapresponse), false,Constant.englishyes?enstr1:knstr1);
                    Constant.intent="";
                  // }
                }:null
            )
          ],
        ),
      );
    }
    else if(type == "soilnutrients"){
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: buildButtonDecoration(isSendByMe),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    controller: nController,
                    key: nFormKey,
                    onEditingComplete: () => node.nextFocus(),
                    style: TextStyle(color: Colors.black54),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"N":"ಸಾರಜನಕ"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _isSubmitNButtonEnabled = _isSoilNValid();
                        nFormKey.currentState.validate();
                      });
                    },
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],
                    validator: (value) {

                      return (value.length>0)
                          ? null
                          : Constant.englishyes?'enter valid number':'ಮಾನ್ಯ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';
                    },
                  ),
                ),
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    controller: pController,
                    key: pFormKey,
                    style: TextStyle(color: Colors.black54),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"P":"ರಂಜಕ"),
                    keyboardType: TextInputType.number,
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (value) {
                      setState(() {
                        _isSubmitNButtonEnabled = _isSoilNValid();
                        pFormKey.currentState.validate();
                      });
                    },
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],
                    validator: (value) {

                      return (value.length>0)
                          ? null
                          : Constant.englishyes?'enter valid number':'ಮಾನ್ಯ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';
                    },
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    controller: kController,
                    key: kFormKey,
                    style: TextStyle(color: Colors.black54),
                    onEditingComplete: () => node.nextFocus(),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"K":"ಪೊಟ್ಯಾಸಿಯಮ್"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _isSubmitNButtonEnabled = _isSoilNValid();
                        kFormKey.currentState.validate();
                      });
                    },
                    validator: (value) {

                      return (value.length>0)
                          ? null
                          : Constant.englishyes?'enter valid number':'ಮಾನ್ಯ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';
                    },
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],

                  ),
                ),
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    controller: ecController,
                    key: ecFormKey,
                    style: TextStyle(color: Colors.black54),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"EC":"ವಿದ್ಯುತ್ ವಾಹಕತೆ"),
                    keyboardType: TextInputType.number,
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (value) {
                      setState(() {
                        // _isSubmitNButtonEnabled = _isSoilNValid();
                        // ecFormKey.currentState.validate();
                      });
                    },
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],

                    // validator: (value) {
                    //
                    //   return (value.length>0)
                    //       ? null
                    //       : 'valid number';
                    // },
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    controller: ocController,
                    key: ocFormKey,
                    style: TextStyle(color: Colors.black54),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"OC":"ಸಾವಯವ ಇಂಗಾಲ"),
                    keyboardType: TextInputType.number,
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (value) {
                      setState(() {
                        // _isSubmitNButtonEnabled = _isSoilNValid();
                        // ocFormKey.currentState.validate();
                      });
                    },
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),],
                    // validator: (value) {
                    //
                    //   return (value.length>0)
                    //       ? null
                    //       : 'valid number';
                    // },
                  ),
                ),
                Container(
                  width: 130,
                  // height: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 5),
                  child: TextFormField(
                    controller: phController,
                    key: phFormKey,
                    style: TextStyle(color: Colors.black54),
                    onEditingComplete: () => node.nextFocus(),
                    decoration: buildTextFieldDecoration(Constant.englishyes?"pH":"ಪಿ ಹೆಚ್"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,1}')),],
                    onChanged: (value) {
                      setState(() {
                        // _isSubmitNButtonEnabled = _isSoilNValid();
                        // phFormKey.currentState.validate();
                      });
                    },
                    // validator: (value) {
                    //   if(double.parse(value)>=10){
                    //     return "value lie between 0 to 10";
                    //   }
                    // }

                  ),
                ),
              ],
            ),

            RaisedButton(
                color: const Color(0xFF0CB14B),
                child: Text(Constant.englishyes?"Submit":"ಸಲ್ಲಿಸು",style: TextStyle(color: Colors.white),),
                onPressed: _isSubmitNButtonEnabled?(){
                  Map<String,String> mapresponse=new Map();
                  String finalmessage="";
                  // if(sandController.text.length==0 ||clayController.text.length==0 ||siltController.text.length==0 ){
                  //
                  // }else{
                  mapresponse["N"]=nController.text;
                  mapresponse["P"]=pController.text;
                  mapresponse["K"]=kController.text;

                  mapresponse["EC"]=ecController.text.isEmpty?"-1":ecController.text;
                  mapresponse["Organic_Carbon"]=ocController.text.isEmpty?"-1":ocController.text;
                  mapresponse["ph"]=phController.text.isEmpty?"-1":phController.text;

                  String n=Constant.englishyes?"N = "+nController.text+" Kg/Ha":"ಸಾರಜನಕ = "+nController.text+" ಕಿ. ಗ್ರಾಂ/ ಹೆ";
                  String p=Constant.englishyes?"P = "+pController.text+" Kg/Ha":"ರಂಜಕ = "+pController.text+" ಕಿ. ಗ್ರಾಂ/ ಹೆ";
                  String k=Constant.englishyes?"K = "+kController.text+" Kg/Ha":"ಪೊಟ್ಯಾಸಿಯಮ್= "+kController.text+" ಕಿ. ಗ್ರಾಂ/ಹೆ";
                  String ec=Constant.englishyes?"EC = "+ecController.text+" dS m-1":"ವಿದ್ಯುತ್ ವಾಹಕತೆ = "+ecController.text+" ಡೆಸಿ-ಸೈಮನ್ಸ್";
                  String oc=Constant.englishyes?"Organic Carbon = "+ocController.text+" %":"ಸಾವಯವ ಇಂಗಾಲ = "+ocController.text+" %";
                  String ph=Constant.englishyes?"pH = "+phController.text:"ಹೈಡ್ರೋಜನ್ ಸಾಮರ್ಥ್ಯ = "+phController.text;
                  if(ocController.text.isEmpty && ecController.text.isEmpty && phController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k;
                  }else if(ocController.text.isEmpty && ecController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k+" "+ph;
                  }else if(ocController.text.isEmpty && phController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k+" "+ec;
                  }else if(ecController.text.isEmpty && phController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k+" "+oc;
                  }else if(ocController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k+" "+ec+" "+ph;
                  }else if(ecController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k+" "+oc+" "+ph;
                  }else if(phController.text.isEmpty){
                    finalmessage=n+" "+p+" "+k+" "+ec+" "+oc;
                  }else {
                    finalmessage=n+" "+p+" "+k+" "+ec+" "+oc+" "+ph;
                  }
                  reponses("/"+Constant.intent+jsonEncode(mapresponse), false,finalmessage);
                  Constant.intent="";
                }:null
            ),
          ],
        ),
      );
    }
    else if(type == "popschedule"){
      List<POP> popList=[];
      Map test = jsonDecode((message.toString().replaceAll("'", '"')));
      test.forEach((mainkey, value) {
        List<SubPop> subPopList=[];
        test[mainkey].forEach((subkey, value) {
          List<String> subvalues=[];
          test[mainkey][subkey].forEach((subkey1, value) {
            subvalues.add(subkey1+"   :   "+value);
          });
          subPopList.add(SubPop(subkey, subvalues));
        });
        popList.add(new POP(mainkey, subPopList));
      });
      return Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for(int j=0;j<popList.length;j++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: buildExpandedDecoration(isSendByMe),
                child: ExpansionTile(
                  expandedCrossAxisAlignment:CrossAxisAlignment.start,
                  title: Text(popList[j].title,style: TextStyle(color: const Color(
                      0xFFEC800E),fontSize: 18,fontWeight: FontWeight.bold)),
                    children: <Widget>[
                      for(int i=0;i<popList[j].subPopList.length;i++)
                        Container(
                          // decoration: BoxDecoration(
                          //   border: Border.all(width: 1)
                          // ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(popList[j].subPopList[i].subtitle,style: TextStyle(color:const Color(
                                  0xFFEC800E),fontSize: 16,fontWeight: FontWeight.w700)),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.3,color:const Color(
                                        0xFFEC800E) )
                                  ),
                              ),
                              for(int k=0;k<popList[j].subPopList[i].details.length;k++)
                                Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                                    child: Text(popList[j].subPopList[i].details[k],style: buildPopTextStyle(isSendByMe),)
                                ),
                            ],
                          ),
                        )
                    ],
                  ),
              )
          ],
        ),
      );
    }
    else if(type == "expandedcard"){
      List<ExpandedCard> expanedCardList=[];
      var test = jsonDecode((message.toString().replaceAll("'", '"')));
      for (int i = 0; i < test.length; i++) {
        var tmp = test[i];
        expanedCardList.add(new ExpandedCard(
          tmp['crop'],
          tmp['data'].cast<String>(),
        ));
      }
      return Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for(int j=0;j<expanedCardList.length;j++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: buildExpandedDecoration(isSendByMe),
                child: ExpansionTile(
                  title: Text(expanedCardList[j].cropname,style: TextStyle(color: const Color(
                      0xFFEC800E),fontSize: 17,fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    for(int i=0;i<expanedCardList[j].list.length;i++)
                      Container(
                          alignment: Alignment.centerLeft,
                          // color:  const Color(0xFFAAC9B6),
                          padding: EdgeInsets.all(5),
                          // decoration: BoxDecoration(
                          //   border: Border(bottom: BorderSide(width: 1,color: Color(
                          //       0xFF88D2A5))),
                          // ),
                          margin: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                          child: Text(expanedCardList[j].list[i])
                      )
                  ],
                ),
              )
          ],
        ),
      );
    }
    else if(type == "labellist"){
      List test = jsonDecode((message.toString().replaceAll("'", '"')));
      List<LabelList> labellist=[];
      test.forEach((element) {
        List<String> values=[];
        element.forEach((mainkey, value) {
          if(mainkey != "_id" &&mainkey != "label"){
            String str="";

            if(value.toString().contains("999")  ||value == "-1" || value == "-1.0" || value == "-1.00"){
              if(mainkey == "Sand" || mainkey == "ಮರಳು"){
                str=mainkey + " : " + 46.toString();
              }else if(mainkey == "Silt" || mainkey == "ಹೂಳು"){
                str=mainkey + " : " + 48.toString();
              }else if(mainkey == "Clay" || mainkey == "ಜೇಡಿಮಣ್ಣು"){
                str=mainkey + " : " + 6.toString();
              }else if(mainkey == "n" || mainkey == "ಸಾರಜನಕ"){
                str=mainkey + " : " + 202.56.toString();
              }else if(mainkey == "p" || mainkey == "ರಂಜಕ"){
                str=mainkey + " : " + 32.52.toString();
              }else if(mainkey == "k" || mainkey == "ಪೊಟ್ಯಾಸಿಯಮ್"){
                str=mainkey + " : " + 199.25.toString();
              }else if(mainkey == "pH" || mainkey == "ಮಣ್ಣಿನ ಕ್ಷಾರೀಯ ಗುಣ"){
                str=mainkey + " : " + 7.01.toString();
              }else if(mainkey == "ec" || mainkey == "ವಿದ್ಯುತ್ ವಾಹಕತೆ"){
                str=mainkey + " : " + 0.2.toString();
              }else if(mainkey == "oc" || mainkey == "ಸಾವಯವ ಇಂಗಾಲ"){
                str=mainkey + " : " + 0.5.toString();
              }else{
                String str3=Constant.englishyes?"Not Available":"ಲಭ್ಯವಿಲ್ಲ";
                str=mainkey + " : " + str3;
              }
            }else{
              if(mainkey == "latitude" ||mainkey == "longitude" || mainkey == "ಅಕ್ಷಾಂಶ" ||mainkey == "ರೇಖಾಂಶ" ){
                var num2 = double.parse( value.toStringAsFixed(6)); // num2 = 10.12
                str=mainkey + ":" + num2.toString();
              }else{
                str=getCapitalizeString(mainkey) + " : " + value.toString();
              }
            }

            values.add(str);
          }
        });
        labellist.add(new LabelList(element["label"], values,element["_id"].toString()));
      });
      Map<String,String> mapresponse=new Map();
    return Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for(int j=0;j<labellist.length;j++)
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-100,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: buildExpandedDecoration(isSendByMe),
                    child: ExpansionTile(
                      title: Text(labellist[j].title,style: TextStyle(color: const Color(
                          0xFFEC800E),fontSize: 17,fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        for(int i=0;i<labellist[j].item.length;i++)
                          Container(
                              alignment: Alignment.centerLeft,
                              // color:  const Color(0xFFAAC9B6),
                              padding: EdgeInsets.all(5),
                              // decoration: BoxDecoration(
                              //   border: Border(bottom: BorderSide(width: 1,color: Color(
                              //       0xFF88D2A5))),
                              // ),
                              margin: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                              child: Text(labellist[j].item[i])
                          ),
                      ],
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: FloatingActionButton(
                      child: Icon(Icons.navigation),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: () => {
                        // print(labellist[j].report_id),
                        if(Constant.servicetype){
                          reponses("/cp_give_report_id"+jsonEncode({"cp_report_id":labellist[j].report_id}), false,"")
                        }else{
                          reponses("/pd_give_label_name"+jsonEncode({"pd_report_id":labellist[j].report_id}), false,"")
                        }
                      },
                    ),
                  ),
                ],
              )

          ],
        ),
      );
    }
  }

  _isSoilPValid(){
    return (((double.parse(sandController.text)+double.parse(clayController.text)+double.parse(siltController.text))==100));
  }

  _isSoilNValid(){
    return ((nFormKey.currentState.isValid &&
        pFormKey.currentState.isValid &&
        kFormKey.currentState.isValid ));

    // return ((nFormKey.currentState.isValid &&
    //     pFormKey.currentState.isValid &&
    //     kFormKey.currentState.isValid &&
    //     phFormKey.currentState.isValid &&
    //     ecFormKey.currentState.isValid &&
    //     ocFormKey.currentState.isValid));
  }

  String getCapitalizeString(String str) {
    if (str.length <= 1) { return str.toUpperCase(); }
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }
  buildBoxDecoration(bool isSendByMe) {
    return BoxDecoration(
      gradient: LinearGradient(
          colors: isSendByMe
          ? [
          // Colors.black
          const Color(0xFF0CB14B),
          const Color(0xFF0CB14B),
          ]
          : [
          const Color(0xFFF0EFF5),
      const Color(0xFFF0EFF5),
      ],
    ),
    borderRadius: isSendByMe
    ? BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
    bottomLeft: Radius.circular(10))
        : BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(10)));
    }

  buildTextStyle(bool isSendByMe) {
    return isSendByMe
        ? TextStyle(color: Colors.white, fontSize: 16)
        : TextStyle(color: Colors.black, fontSize: 16);
  }

  buildButtonTextStyle(bool isSendByMe) {
    return TextStyle(
      // color: Color(0xFFEC800E),
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16);
  }

  buildPopTextStyle(bool isSendByMe) {
    return isSendByMe
        ? TextStyle(color: Colors.white, fontSize: 15)
        : TextStyle(color: Colors.black, fontSize: 15);
  }

  buildButtonDecoration(bool isSendByMe) {
    return BoxDecoration(
      color: isSendByMe ? const Color(0xFF0CB14B):const Color(0xFFF0EFF5),
      borderRadius: BorderRadius.all(Radius.circular(5)),
      // border: Border.all(width: 1,color:Color(0xFFEC800E) )
      // boxShadow: [
      //   BoxShadow(
      //     color: const Color(0xFFF0EFF5).withOpacity(0.5),
      //     spreadRadius: 5,
      //     blurRadius: 4,
      //     offset: Offset(0, 3), // changes position of shadow
      //   ),
      // ],
    );
  }

  buildExpandedDecoration(bool isSendByMe) {
    return BoxDecoration(
      color: isSendByMe ? const Color(0xFF0CB14B):const Color(0xFFF0EFF5),
      borderRadius: BorderRadius.all(Radius.circular(5)),
      border: Border.all(width: 1,color: Color(0xFFEC800E))
      // boxShadow: [
      //   BoxShadow(
      //     color: const Color(0xFFF0EFF5).withOpacity(0.5),
      //     spreadRadius: 5,
      //     blurRadius: 4,
      //     offset: Offset(0, 3), // changes position of shadow
      //   ),
      // ],
    );
  }

  buildTextFieldDecoration(String label) {
    return InputDecoration(

      labelText: label,
      hintStyle: TextStyle(color: Colors.black54),
      // hintText: textFieldList[index],
      labelStyle: TextStyle(color: const Color(0xFF0CB14B)),
      enabledBorder: new OutlineInputBorder(
          borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
      focusedBorder: new OutlineInputBorder(
          borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
      border:  new OutlineInputBorder(
          borderSide: new BorderSide(color: const Color(0xFF0CB14B))),
    );
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


class Button1 {
  String name, response,intent;
  Button1(this.name,this.intent, this.response);
}


class MyItem {
  MyItem({ this.isExpanded: false, this.header, this.body });

  bool isExpanded;
  final String header;
  final String body;
}

class LabelList{
  String title;
  List<String> item;
  String report_id;


  LabelList(this.title, this.item, this.report_id);

}