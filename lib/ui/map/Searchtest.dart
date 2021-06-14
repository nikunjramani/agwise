import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchList extends StatefulWidget {
  SearchList({Key key, this.name}) : super(key: key);

  final String name;

  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Widget appBarTitle = new Text(
    "",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<SearchResult> _list;
  bool _IsSearching;
  String _searchText = "";
  String selectedSearchValue = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    createSearchResultList();
  }

  void createSearchResultList() {
    _list = <SearchResult>[
      new SearchResult( 'Google'),
      new SearchResult('IOS'),
      new SearchResult( 'IOS2'),
      new SearchResult( 'Android'),
      new SearchResult('Dart'),
      new SearchResult('Flutter'),
      new SearchResult('Python'),
      new SearchResult('React'),
      new SearchResult('Xamarin'),
      new SearchResult('Kotlin'),
      new SearchResult('Java'),
      new SearchResult('RxAndroid'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: key,
        appBar: buildBar(context),
        body: new Stack(
          children: <Widget>[
            new Container(
              height: 300.0,
              padding: EdgeInsets.all(10.0),
              child: new Container(

              ),
            ),
            displaySearchResults(),
          ],
        ));
  }

  Widget displaySearchResults() {
    if (_IsSearching) {
      return new Align(
          alignment: Alignment.topCenter,
          child: searchList());
    } else {
      return new Align(alignment: Alignment.topCenter, child: new Container());
    }
  }

  ListView searchList() {
    List<SearchResult> results = _buildSearchList();
    return ListView.builder(
      itemCount: _buildSearchList().isEmpty == null ? 0 : results.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: new BoxDecoration(
              color: Colors.grey[100],
              border: new Border(
                  bottom: new BorderSide(
                      color: Colors.grey,
                      width: 0.5
                  )
              )
          ),

          child: ListTile(
            onTap: (){},
            title: Text(results.elementAt(index).name,
                style: new TextStyle(fontSize: 18.0)),
          ),
        );
      },
    );
  }

  List<SearchResult> _buildList() {
    return _list.map((result) => new SearchResult( result.name)).toList();
  }

  List<SearchResult> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((result) => new SearchResult( result.name)).toList();
    } else {
      List<SearchResult> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        SearchResult result = _list.elementAt(i);
        if ((result.name).toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(result);
        }
      }
      return _searchList
          .map((result) => new SearchResult(result.name))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            _displayTextField();
          },
        ),

        // new IconButton(icon: new Icon(Icons.more), onPressed: _IsSearching ? _showDialog(context, _buildSearchList()) : _showDialog(context,_buildList()))
      ],
    );
  }

  String selectedPopupRoute = "My Home";
  final List<String> popupRoutes = <String>[
    "My Home",
    "Favorite Room 1",
    "Favorite Room 2"
  ];

  void _displayTextField() {
    setState(() {
      if (this.actionIcon.icon == Icons.search) {
        this.actionIcon = new Icon(
          Icons.close,
          color: Colors.white,
        );
        this.appBarTitle = new TextField(
          autofocus: true,
          controller: _searchQuery,
          style: new TextStyle(
            color: Colors.white,
          ),
        );

        _handleSearchStart();
      } else {
        _handleSearchEnd();
      }
    });
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }
}

class SearchResult{
  String name;

  SearchResult(this.name);
}