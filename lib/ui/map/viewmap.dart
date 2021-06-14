import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/models/Chat.dart';
import 'package:agtech_farmer/ui/chatscreen/chatscreen.dart';
import 'package:agtech_farmer/ui/map/widgets/MapBoxSearch.dart';
import 'package:agtech_farmer/ui/map/widgets/plugin_zoombuttons.dart';
import 'package:agtech_farmer/utils/searchlocationcoordinates.dart';
import 'package:agtech_farmer/utils/getcurrentlocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewMap extends StatefulWidget {
  Future<void> Function(String msg, bool sendornot, String dummymessage) reponses;
  void Function(int id, String message, bool isSendByMe, String type) addChatToChatList;

  ViewMap(this.reponses,this.addChatToChatList);

  @override
  _MapState createState() => _MapState(reponses,addChatToChatList);
}

class _MapState extends State<ViewMap> {
  List<LatLng> _polygon = List<LatLng>();
  LatLng _pin;
  LatLng currentlocation;
  // Position location;
  bool drawpolygon = false, droppin = true;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( Constant.englishyes?'Map':"ನಕ್ಷೆ" );
  MapController mapController;
  Position location;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> Function(String msg, bool sendornot, String dummymessage) responses;
  void Function(int id, String message, bool isSendByMe, String type) addChatToChatList;

  _MapState(this.responses,this.addChatToChatList);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: Container(
        child: Stack(
          children: [
            new FlutterMap(
              mapController: mapController,
                options: new MapOptions(
                    // debugMultiFingerGestureWinner: true,
                    //   enableMultiFingerGestureRace: true,
                    plugins: [
                      ZoomButtonsPlugin()
                    ],
                    center: LatLng(13.716679, 77.064220),
                    // minZoom: 13.0,
                    onTap: (latlng) {
                      if (drawpolygon) {
                        onTapCreatePolygon(latlng);
                      } else if (droppin) {
                        onTapCreatePin(latlng);
                      }
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
                  getlayer(),
                  getPin(),
                ],
              // nonRotatedLayers: [
              //   ZoomButtonsPluginOption(
              //     minZoom: 4,
              //     maxZoom: 19,
              //     mini: true,
              //     padding: 20,
              //     alignment: Alignment.bottomRight,
              //   ),
              // ],
            ),

            // SpeedDial(
            //   /// both default to 16
            //   // marginEnd: MediaQuery.of(context).size.width-50,
            //   marginBottom: 20,
            //   // animatedIcon: AnimatedIcons.menu_close,
            //   // animatedIconTheme: IconThemeData(size: 22.0),
            //   /// This is ignored if animatedIcon is non null
            //   icon: Icons.add,
            //   activeIcon: Icons.remove,
            //   // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
            //   /// The label of the main button.
            //   // label: Text("Open Speed Dial"),
            //   /// The active label of the main button, Defaults to label if not specified.
            //   // activeLabel: Text("Close Speed Dial"),
            //   /// Transition Builder between label and activeLabel, defaults to FadeTransition.
            //   // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
            //   /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
            //   // buttonSize: 56.0,
            //   visible: true,
            //
            //   /// If true user is forced to close dial manually
            //   /// by tapping main button and overlay is not rendered.
            //   closeManually: false,
            //
            //   /// If true overlay will render no matter what.
            //   renderOverlay: false,
            //   curve: Curves.bounceIn,
            //   overlayColor: Colors.black,
            //   overlayOpacity: 0.5,
            //   // onOpen: () => print('OPENING DIAL'),
            //   // onClose: () => print('DIAL CLOSED'),
            //   tooltip: 'Speed Dial',
            //   heroTag: 'speed-dial-hero-tag',
            //   backgroundColor: const Color(0xFF0CB14B),
            //   foregroundColor: Colors.white,
            //   elevation: 8.0,
            //   shape: CircleBorder(),
            //   orientation: SpeedDialOrientation.Up,
            //   childMarginBottom: 10,
            //   childMarginTop: 10,
            //   children: [
            //     SpeedDialChild(
            //       child: Icon(
            //         Icons.wrong_location,
            //         color: Colors.white,
            //       ),
            //       backgroundColor: Colors.red,
            //       label: 'Clear',
            //       labelStyle: TextStyle(fontSize: 18.0),
            //       onTap: () {
            //         setState(() {
            //           _polygon = [];
            //           _pin = null;
            //         });
            //       },
            //     ),
            //     SpeedDialChild(
            //       child: Icon(
            //         Icons.map_outlined,
            //         color: Colors.white,
            //       ),
            //       backgroundColor: Colors.green,
            //       label: 'Polygon',
            //       labelStyle: TextStyle(fontSize: 18.0),
            //       onTap: () {
            //         setState(() {
            //           _pin = null;
            //           drawpolygon = true;
            //           droppin = false;
            //         });
            //       },
            //     ),
            //     SpeedDialChild(
            //       child: Icon(
            //         Icons.pin_drop,
            //         color: Colors.white,
            //       ),
            //       backgroundColor: Colors.blue,
            //       label: 'Pin',
            //       labelStyle: TextStyle(fontSize: 18.0),
            //       onTap: () {
            //         setState(() {
            //           _polygon = [];
            //           droppin = true;
            //           drawpolygon = false;
            //         });
            //       },
            //     ),
            //   ],
            // ),

            Container(
                margin: EdgeInsets.only(bottom: 5),
                alignment: Alignment.bottomRight,
                child: RawMaterialButton(
                  onPressed: () async {
                    if(_pin==null){
                      showInSnackBar("Please add your farm location");
                    }
                    else{
                      addChatToChatList(0, _pin.latitude.toString()+"&"+_pin.longitude.toString(), true, "map");
                      // Constant.chatlist.add(new Chat(0, _pin.latitude.toString()+"&"+_pin.longitude.toString(), true, "map"));
                      responses(Constant.intent+jsonEncode({"lat":_pin.latitude,"lng":_pin.longitude}), false,"");
                      // responses(Constant.intent+jsonEncode({"lat":-999,"lng":-999}), false,"");

                      // responses(Constant.englishyes?"Latitude="+_pin.latitude.toString()+" Longitude="+_pin.latitude.toString()+" ":"ಅಕ್ಷಾಂಶ ="+_pin.latitude.toString()+" ರೇಖಾಂಶ = "+_pin.longitude.toString(), false,"");
                      Navigator.of(context).pop(
                          MaterialPageRoute(builder: (context) => ChatScreen()));
                    }
                  },
                  elevation: 2.0,
                  fillColor: const Color(0xFF0CB14B),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )),
            // MapBoxPlaceSearchWidget(
            //   // popOnSelect: true,
            //   apiKey: "pk.eyJ1IjoibmlrdW5qcmFtYW5pNzYyNCIsImEiOiJja29iN2YxdmYwamxyMnVveTZkdXdzM3lkIn0.sruhXMb6uLQT563JVxA8Sg",
            //   searchHint: 'Your Hint here',
            //   onSelected: (place) async {
            //     print(place.placeName);
            //
            //     final query = place.placeName;
            //     var addresses = await Geocoder.local.findAddressesFromQuery(query);
            //     var first = addresses.first;
            //     currentlocation=new LatLng(first.coordinates.latitude,first.coordinates.longitude);
            //     mapController.move(currentlocation, 15);
            //     print("${first.featureName} : ${first.coordinates}");
            //
            //   },
            //   context: context,
            // )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    initStateFunctions();
  }

  Future<void> initStateFunctions() async {
    location=await getCurrentLocation();
    // setState(() {
    //   currentlocation=new LatLng(location.latitude,location.longitude);
    //   mapController.move(currentlocation);
    // });


    getPermission();
  }


  Widget buildAppBar() {
    return AppBar(
      titleSpacing: -10,
      title: _appBarTitle,
      backgroundColor: const Color(0xFF0CB14B),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // actions: [
      //   IconButton(
      //     icon: _searchIcon,
      //     onPressed: _searchPressed,
      //   ),
      // ],
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close,color: Colors.white,);
        this._appBarTitle = new TextField(
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search,color: Colors.white,),
              hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white)
          ),
          textAlign: TextAlign.start,
            textAlignVertical:TextAlignVertical.center,
          style: TextStyle(
              color:Colors.white
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search,color: Colors.white,);
        this._appBarTitle = new Text('Map');
      }
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(value),
        )
    );
  }

  LayerOptions getlayer() {
    return drawpolygon
        ? (_polygon == null || _polygon.isEmpty)
            ? PolygonLayerOptions()
            : PolygonLayerOptions(polygons: [
                Polygon(
                  points: _polygon,
                  color: const Color(0xCB14B),
                  borderStrokeWidth: 5.0,
                  borderColor: const Color(0xFF0CB14B),
                )
              ])
        : PolygonLayerOptions();
  }

  LayerOptions getPin() {
    return droppin
        ? MarkerLayerOptions(
            markers: [
              Marker(
                point: _pin,
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
        : MarkerLayerOptions();
  }

  onTapCreatePolygon(latlng) {
    setState(() {
      _polygon.add(LatLng(latlng.latitude, latlng.longitude));
    });
  }

  onTapCreatePin(latlng) {
    setState(() {
      _pin = LatLng(latlng.latitude, latlng.longitude);
    });
  }

  Future<void> getPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }
    // if (await Permission.contacts.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    // }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
  }

}
