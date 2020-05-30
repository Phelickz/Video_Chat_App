import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/models/user.dart';
import 'package:video_chat/screens/chatScreen.dart';
import 'package:video_chat/services/firestore.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/utils/colors.dart';
import 'package:video_chat/widgets/avatar.dart';
import 'package:video_chat/widgets/chat_tile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _userID;

  DbCalls _dbCalls = DbCalls();

  List<User> userList;
  String query = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  Future<void> getUserID() async {
    final uid = await Provider.of<AuthenticationState>(context, listen: false)
        .currentUserId();
    if(uid != null){
      _dbCalls.getAllUsers(uid).then((List<User> list) {
        setState(() {
          userList = list;
          _userID = uid;
        });
      }).catchError((e) {
        print(e);
      });
    }
    return;
  }

  getQuerySuggestions(String query) {
    final List<User> queryList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _username = user.username.toLowerCase();
            String _query = query.toLowerCase();
            // String _name = user.name.toLowerCase();
            bool matchUsername = _username.contains(_query);
            // bool matchName = _name.contains(_query);

            return (matchUsername);
          }).toList();

    return ListView.builder(
        itemCount: queryList.length,
        itemBuilder: (context, index) {
          var _data = queryList[index];
          return ChatTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiver: _data,)));
            },
            small: false,
            leading: Avatar(),
            title: Text(_data.username, style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),),
            subtitle: Text('send a message', style: TextStyle(
              color: Colors.white54
            )),
          );
        });
  }

  Widget _searchBar(context, double width, double height) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          color: Colors.white,
          width: width,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Container(
                width: MediaQuery.of(context).size.width * 0.87,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      query = val;
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search username",
                      hintStyle: TextStyle(
                        color: Colors.black54
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.close, color: Colors.black,),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _searchController.clear();
                            });
                          })),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
          child: Scaffold(
        backgroundColor: GlobalColors.blackColor,
        body: Column(
          children: <Widget>[
            _searchBar(context, width, height),
            Expanded(
          
              child: Container(
                child: getQuerySuggestions(query),
              ),
            )
          ],
        ),
      ),
    );
  }
}
