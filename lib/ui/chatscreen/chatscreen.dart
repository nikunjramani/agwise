import 'dart:convert';
import 'dart:ffi';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/constants/custometheme.dart';
import 'package:agtech_farmer/models/Chat.dart';
import 'package:agtech_farmer/models/ExpandedCard.dart';
import 'package:agtech_farmer/models/POP.dart';
import 'package:agtech_farmer/models/ProfitablityTable.dart';
import 'package:agtech_farmer/services/SharedPrederence.dart';
import 'package:agtech_farmer/ui/chatscreen/widgets/chatwidgets.dart';
import 'package:agtech_farmer/ui/login/login.dart';
import 'package:agtech_farmer/ui/map/viewmap.dart';
import 'package:agtech_farmer/utils/replaceemojis.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = new TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Stream chatMessageStream;
  bool type = false;
  double screen_height = 0;
  double screen_width = 0;
  List<String> question = [Constant.englishyes?"List Of Services":"ಸೇವೆಗಳ ಪಟ್ಟಿಯನ್ನು ನನಗೆ ನೀಡಿ."];
  bool _needsScroll = false;
  bool islabelnameisvaild=false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToEnd());
      _needsScroll = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(Constant.englishyes?"AgWise(Beta)":"ಆಗ್ವೈಸ್(ಬೀಟಾ)"),
      body: Container(
        // data: lightTheme,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChatMessageList(),
            buildChatController()
          ],
        ),
      ),
    );
  }

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
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {Constant.englishyes?'Clear Chat':'ಸಂದೇಶಗಳನ್ನು ತೆರವುಗೊಳಿಸಿ','English',Constant.englishyes?'Kannada':'ಕನ್ನಡ',Constant.englishyes?'Logout':'ಲಾಗ್ ಔಟ್'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  void handleClick(String value) {
    if(value=="English" ||value=="ಆಂಗ್ಲ") {
      setState(() {
        Constant.chatlist = [];
        SharedPreference.saveLanguage("English");
        Constant.englishyes = true;
        question=['List Of Services'];
      });
      getResponse("/list_services_services_list", false,"");
    }
    else if(value=="Kannada" || value=="ಕನ್ನಡ") {
      setState(() {
        Constant.chatlist = [];
        SharedPreference.saveLanguage("Kannada");
        Constant.englishyes=false;
        question=['ಸೇವೆಗಳ ಪಟ್ಟಿಯನ್ನು ನನಗೆ ನೀಡಿ.'];
      });
      getResponse("/list_services_services_list", false,"");
    }
    else if(value=="Logout" || value=="ಲಾಗ್ ಔಟ್") {
      SharedPreference.saveIsUserLogin(false);
      setState(() {
        Constant.chatlist = [];
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
      });
    }
    else{
      setState(() {
        Constant.chatlist = [];
      });
    }

  }

  Widget ChatMessageList() {
    return Expanded(
      child: Constant.chatlist != null
          ? ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          // reverse: true,
          controller: _scrollController,
          itemCount: Constant.chatlist.length,
          itemBuilder: (context, index) {
            String type = Constant.chatlist[index].type;
            String message = Constant.chatlist[index].msg;
            bool isSendByMe = Constant.chatlist[index].issendbyme;
            return  Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.symmetric(vertical: 1),
                // width: MediaQuery.of(context).size.width,
                alignment: isSendByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: ChatWidgets(type,message,isSendByMe,getResponse,addChatToChatList)
            );
          })
          : Container(),
    );
  }

  Widget BuildsuggestedQuestion() {
    return Container(
      child: SizedBox(
        // Horizontal ListView
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: question.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                  if(Constant.msgslot != null){
                  addChatToChatList(0, Constant.englishyes?"Please enter profile name":"", false, "message"),
                  }else{
                    getResponse("/list_services_services_list", false,question[index]),
                  }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEC800E),
                        border: new Border.all(
                            color: const Color(0xFFEC800E), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      '${question[index]}',
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                );
              })),
    );
  }

  Widget buildChatController() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          BuildsuggestedQuestion(),
          Container(
            // height:50 ,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical:3, horizontal: 5),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: const Color(0xFFF0EFF5),
                // border: new Border.all(color: Color.fromRGBO(12,177,75,.9), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: new Row(
              children: [
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: TextField(
                        maxLines: null,
                        maxLengthEnforced: false,
                        textInputAction: TextInputAction.send,
                        // keyboardType: TextInputType.multiline,
                        controller: messageController,

                        style: TextStyle(color: Colors.black54),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black54),
                            hintText: Constant.englishyes?"Enter Message":"ಸಂದೇಶವನ್ನು ನಮೂದಿಸಿ",
                            border: InputBorder.none),
                      ),
                    )),
                // GestureDetector(
                //   onTap: () => {
                //     showModalBottomSheet(
                //         context: context,
                //         isDismissible: true,
                //         builder: (builder) {
                //           return new Container(
                //             padding: EdgeInsets.all(5),
                //             height: 150.0,
                //             color: Color(0xFF737373),
                //             child: new Container(
                //                 decoration: new BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius: new BorderRadius.only(
                //                         topLeft: const Radius.circular(10.0),
                //                         topRight: const Radius.circular(10.0))),
                //                 child: Container(
                //                   padding: EdgeInsets.all(10),
                //                   child: Column(
                //                     children: [
                //                       Row(
                //                         mainAxisAlignment: MainAxisAlignment.center,
                //                         children: [
                //                           Container(
                //                             width:screen_width * 0.30,
                //                             padding: EdgeInsets.symmetric(
                //                                 horizontal: 20, vertical: 12),
                //                             child: Column(
                //                               children: [
                //                                 Container(
                //                                   child: GestureDetector(
                //                                     child: Container(
                //                                       height: 60,
                //                                       width: 60,
                //                                       decoration: BoxDecoration(
                //                                           color: const Color(
                //                                               0xFF0CB14B),
                //                                           borderRadius:
                //                                           BorderRadius
                //                                               .circular(
                //                                               50)),
                //                                       child: Icon(
                //                                         Icons.image,
                //                                         color: Colors.white,
                //                                         size: 30,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(
                //                                   height: 10,
                //                                 ),
                //                                 Text("Image")
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             width:screen_width * 0.30,
                //                             padding: EdgeInsets.symmetric(
                //                                 horizontal: 20, vertical: 12),
                //                             child: Column(
                //                               children: [
                //                                 Container(
                //                                   child: GestureDetector(
                //                                     // onTap: _takePhoto,
                //                                     child: Container(
                //                                       height: 60,
                //                                       width: 60,
                //                                       decoration: BoxDecoration(
                //                                           color: const Color(
                //                                               0xFF0CB14B),
                //                                           borderRadius:
                //                                           BorderRadius
                //                                               .circular(
                //                                               50)),
                //                                       child: Icon(
                //                                         Icons
                //                                             .camera_alt_outlined,
                //                                         color: Colors.white,
                //                                         size: 30,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(
                //                                   height: 10,
                //                                 ),
                //                                 Text("Camera")
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             width:screen_width * 0.30,
                //                             padding: EdgeInsets.symmetric(
                //                                 horizontal: 20, vertical: 12),
                //                             child: Column(
                //                               children: [
                //                                 Container(
                //                                   child: GestureDetector(
                //                                     onTap: () => {
                //                                       Navigator.pop(context),
                //                                       Navigator.of(context).push(
                //                                           MaterialPageRoute(
                //                                               builder:
                //                                                   (context) =>
                //                                                   ViewMap(getResponse)))
                //                                     },
                //                                     child: Container(
                //                                       height: 60,
                //                                       width: 60,
                //                                       decoration: BoxDecoration(
                //                                           color: const Color(
                //                                               0xFF0CB14B),
                //                                           borderRadius:
                //                                           BorderRadius
                //                                               .circular(
                //                                               50)),
                //                                       child: Icon(
                //                                         Icons.map_rounded,
                //                                         color: Colors.white,
                //                                         size: 30,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(
                //                                   height: 10,
                //                                 ),
                //                                 Text("Map")
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 )),
                //           );
                //         })
                //   },
                //   child: Container(
                //       height: 40,
                //       width: 40,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(30)),
                //       padding: EdgeInsets.all(5),
                //       child: Icon(
                //         Icons.attachment_outlined,
                //         size: 30,
                //         color: const Color(0xFF0CB14B),
                //       )),
                // ),
                buildSendButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSendButton() {
    messageController.addListener(() {
      if (messageController.text.isNotEmpty) {
        setState(() {
          type = true;
        });
      } else {
        setState(() {
          type = false;
        });
      }
    });
    return GestureDetector(
      onTap: () => {
        if (messageController.text.isNotEmpty){
          if(Constant.msgslot != null){
              Constant.labellist.forEach((element) {
                if(messageController.text==element){
                  islabelnameisvaild=true;
                }
              }),
              if(islabelnameisvaild){
                addChatToChatList(0, Constant.englishyes?"You have a Soil and Location profile with same name. Try giving some other profile name.":"ನೀವು ಒಂದೇ ಹೆಸರಿನೊಂದಿಗೆ ಮಣ್ಣು ಮತ್ತು ಸ್ಥಳ ಪ್ರೊಫೈಲ್ ಹೊಂದಿದ್ದೀರಿ. ಬೇರೆ ಕೆಲವು ಪ್ರೊಫೈಲ್ ಹೆಸರನ್ನು ನೀಡಲು ಪ್ರಯತ್ನಿಸಿ.", false, "message"),
                islabelnameisvaild=false
              }else{
                getResponse(messageController.text, true,""),
                islabelnameisvaild=false
              }
          }else{
            addChatToChatList(0, Constant.englishyes?"Entering text is currently not supported for this question. We are working on including this feature. For now, please use the buttons provided on the screen":"ಪಠ್ಯವನ್ನು ನಮೂದಿಸುವುದನ್ನು ಪ್ರಸ್ತುತ ಈ ಪ್ರಶ್ನೆಗೆ ಬೆಂಬಲಿಸುವುದಿಲ್ಲ. ಈ ವೈಶಿಷ್ಟ್ಯವನ್ನು ಸೇರಿಸುವಲ್ಲಿ ನಾವು ಕೆಲಸ ಮಾಡುತ್ತಿದ್ದೇವೆ. ಇದೀಗ, ದಯವಿಟ್ಟು ಪರದೆಯಲ್ಲಿ ಒದಗಿಸಲಾದ ಗುಂಡಿಗಳನ್ನು ಬಳಸಿ", false, "message")
          }

        }
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xFF0CB14B),
              const Color(0xFF0CB14B),
            ]),
            borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.all(5),
        child: !type
            ? Icon(
          Icons.arrow_upward,
          color: Colors.white,
        )
            : Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        _handleNotification(message.data);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      _handleNotification(message.data);
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      _handleNotification(message.data);
    });
    FirebaseMessaging.onBackgroundMessage((message) => _handleNotification(message.data));
    getResponse("/list_services_services_list", false, "");
    getLabelList();
  }

  Future<void> _handleNotification(
      Map<dynamic, dynamic> message) async {
    var data = message['data'] ?? message;
    String report_id = data['report_id'];
    String type = data['type'];
    String crop = data['crop'];
    if(type=="suitability"){
      getResponse("/cp_give_report_id"+jsonEncode({"cp_report_id":report_id}), false, "");
    }else if(type=="plantingdate"){
      getResponse("/planting_date_crop_selection"+jsonEncode({"pd_report_id":report_id,"pd_crop":crop}), false, "");
    }
  }

  Future<void> getResponse(String msg, bool sendornot,String dummymessage) async {
    if (sendornot) {
      setState(() {
        messageController.text="";
        addChatToChatList(0, msg, true, "message");
      });
    }else{
      setState(() {
        if(dummymessage.length>=1){
          addChatToChatList(0, dummymessage, true, "message");
        }
      });
    }

    final Map<String, String> header = {
      'Accept-Language': '*',
      'x-user': Constant.farmerid,
      "Authorization":  Constant.englishyes?Constant.englishauthtoken:Constant.kannadaauthtoken
    };
    String finalmsg="";
    if(Constant.msgslot != null){
      Map<String,String> mapmsg=new Map();
      mapmsg[Constant.msgslot]=msg;
      if(Constant.servicetype){
        mapmsg["report_type"]="suitability";
      }else{
        mapmsg["report_type"]="plantingdate";
      }
      Constant.labellist.add(msg);
      finalmsg="/"+Constant.msgintent+jsonEncode(mapmsg);
      Constant.msgintent=null;
      Constant.msgslot=null;
    }else{
      finalmsg=msg;
    }
    print(finalmsg);

    if(finalmsg=="/crop_selection_start"){
      Constant.servicetype=true;
    }else if(finalmsg=="/planting_date_start"){
      Constant.servicetype=false;
    }

    var data = jsonEncode(<String, dynamic>{
      'data': finalmsg,
    });

    Uri url = Uri.parse("https://kairon-api.digite.com/api/bot/chat");
    var response = await http.post(url, headers: header, body: data);
    var response1 = json.decode(utf8.decode(response.bodyBytes));
    print(response1.toString());
    try{
      for(int i=0;i<response1['data']['response'].length;i++){
        var text=json.decode(response1['data']['response'][i]['text'].replaceAll("'", '"'));
        // print(text);

        try{


        for(int j=0;j<text.length;j++) {
          var jsonResponse = text[j];
          // var jsonResponse= json.decode(response1['data']['response'][i]);
          switch (jsonResponse['type']) {
              case 'message':
                List<dynamic> messagesList = jsonResponse['message'];
                String messages = '';
                for(int k=0;k<messagesList.length;k++){
                  if(k==messagesList.length-1){
                    messages += ReplaceEmojis.replaceEmoji(messagesList[k]);
                  }else{
                    messages += ReplaceEmojis.replaceEmoji(messagesList[k]) +'\n\n';
                  }
                }

                addChatToChatList(0, messages, false, "message");
                Constant.msgintent=jsonResponse['intent'];
                Constant.msgslot=jsonResponse['slot'];

                //todo check slot value available using if condition

                break;
            case 'backendmessage':
              List<dynamic> messagesList = jsonResponse['message'].toString().split("#^nnn^#");
              String messages = '';
              for(int k=0;k<messagesList.length;k++){
                if(k==messagesList.length-1){
                  messages += ReplaceEmojis.replaceEmoji(messagesList[k]);
                }else{
                  messages += ReplaceEmojis.replaceEmoji(messagesList[k]) +'\n\n';
                }
              }

              addChatToChatList(0, messages, false, "message");
              Constant.msgintent=jsonResponse['intent'];
              Constant.msgslot=jsonResponse['slot'];

              //todo check slot value available using if condition

              break;  
              case 'buttons':
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "buttons");
                break;
              case 'forms':
                Constant.intent=jsonResponse['intent'];
                Constant.formsslot=jsonResponse['slot'];
                print(Constant.formsslot);
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "forms");
                break;
              case 'soilphysical':
                Constant.intent=jsonResponse['intent'];
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "soilphysical");
                break;
              case 'soilnutrients':
                Constant.intent=jsonResponse['intent'];
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "soilnutrients");
                break;
              case 'expandedcard':
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "expandedcard");
                break;
              case 'popschedule':
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "popschedule");
                break;
              case 'actionbuttons':
                addChatToChatList(
                    0, jsonEncode(jsonResponse['message']), false, "actionbutton");
                break;
              case 'askkairon':
                getResponse(jsonResponse['message'], false, "");
                break;
              case 'labellist':
                addChatToChatList(0, jsonEncode(jsonResponse['message']), false, "labellist");
                break;
            }

        }
        }
        catch(e){
          // addChatToChatList(0, response1.toString(), true, "message");
          getResponse("/list_services_services_list", false, "");
        }
      }

    }catch(e){
      // addChatToChatList(0, response1.toString(), true, "message");
      getResponse("/list_services_services_list", false, "");
    }
  }

  void addChatToChatList(int id, String message, bool isSendByMe, String type) {
    setState(() {
      Constant.chatlist.add(new Chat(id, message, isSendByMe, type));
      _needsScroll = true;
    });
  }

  _scrollToEnd() async {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut
    );
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
  //
  // void _takePhoto() async {
  //   ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 10)
  //       .then((File recordedImage) async {
  //     if (recordedImage != null && recordedImage.path != null) {
  //       setState(() {
  //         Constant.chatlist.add(new Chat(0, recordedImage.path, true, "image"));
  //       });
  //     }
  //   });
  // }

Future<void> getLabelList() async {
  final Map<String, String> header = {
    'Accept-Language': '*',
  };
  var data = jsonEncode(<String, dynamic>{
    'farmer_id': Constant.farmerid,
    'locale':Constant.englishyes?'en':'kn'
  });
  Uri url = Uri.parse(Constant.serverurl+"getlabel/");
  var response = await http.post(url, headers: header, body: data);
  try{
    var response1 = json.decode(utf8.decode(response.bodyBytes));
    for(int i=0;i<response1[0]['message'].length;i++){
      Constant.labellist.add(response1[0]['message'][i]["label"]);
    }
  }catch(e){
    Constant.labellist=[];
  }

  print(Constant.labellist);
}

}
