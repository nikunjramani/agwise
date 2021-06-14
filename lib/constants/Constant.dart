import 'package:agtech_farmer/models/Chat.dart';
import 'package:agtech_farmer/models/ExpandedCard.dart';
import 'package:agtech_farmer/models/POP.dart';
import 'package:agtech_farmer/models/ProfitablityTable.dart';
import 'package:agtech_farmer/models/farmer.dart';
import 'package:agtech_farmer/ui/chatscreen/widgets/chatwidgets.dart';
import 'package:agtech_farmer/ui/signup/signup.dart';

class Constant{
  static String serverurl="https://agwise.digite.com/";
  static List<Chat> chatlist=[];
  static String imagepath="";
  static String farmerid="";
  static String farmername="";
  static String kannadafarmername="";
  static String number="";
  static double latitude;
  static double longitude;
  static List<Farmer> farmerlist=[];
  static String xuser="Agtech-Nikunj";
  static String firebasetoken="";
  static bool englishyes=true;
  static String englishauthtoken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2MDkzN2YyZDkwZTQ0OWM1MzljN2QzY2FAaW50ZWdyYXRpb24uY29tIn0.Tg9OrQtxdQ4FQAk2IkLw3jML4p9v9d5hUoSMWqdqjwQ";
  static String kannadaauthtoken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2MDllNjlhNDI1MDIzMDEyNDk5MTk3YjFAaW50ZWdyYXRpb24uY29tIn0.dgAlWtRk__4IguUyZW0Cqlt5-BRcrVSo8tikZkvEKYM";
  static String intent="";
  static String slot=null;
  static String msgslot=null;
  static String msgintent="";
  static bool servicetype=true;
  static var formsslot=[];
  static String report_id="";
  static String type ="";
  static String crop="";
  static bool checknotification=false;
  static List<String> labellist=[];
}