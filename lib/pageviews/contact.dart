import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/screens/login.dart';
import 'package:video_chat/services/firestore.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/state/userState.dart';
import 'package:video_chat/utils/colors.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DbCalls dbCalls = DbCalls();
  var _darkTheme = false;
  String _uid;
  @override
  void initState() {
    getUid();
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    dbCalls.getUsersData(userNotifier, _uid);
    super.initState();
  }

  Future<void> getUid() async {
    var uid = await Provider.of<AuthenticationState>(context, listen: false)
        .currentUserId();
    setState(() {
      this._uid = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    double height = MediaQuery.of(context).size.width;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: GlobalColors.blackColor,
      appBar: AppBar(
        backgroundColor: GlobalColors.blackColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.more_vert,
              ),
              onPressed: _modalBottomSheetMenu)
        ],
        title: Text('Profile', style: GoogleFonts.aBeeZee()),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: userNotifier.userProfileData.isNotEmpty
          ? ListView.builder(
              itemCount: userNotifier.userProfileData.length,
              itemBuilder: (context, index) {
                var _data = userNotifier.userProfileData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_data.profilePhoto),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            _data.username,
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          _data.email,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  _darkTheme ? Colors.white54 : Colors.black54),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          _data.state == 1 ? "Online": "Offline",
                          style: GoogleFonts.aBeeZee(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  _darkTheme ? Colors.white54 : Colors.black54),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        // backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (builder) {
          final auth = Provider.of<AuthenticationState>(context);

          return new Container(
            padding: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height * 0.2,
            // color: Color(0xFF737373), //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(
                    Icons.exit_to_app,
                    // color: Colors.black,
                  ),
                  title: new Text(
                    'Sign out',
                    style: TextStyle(
                        // color: Colors.black,
                        ),
                  ),
                  onTap: () async {
                    auth.logout().then((_){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.settings,
                    // color: Colors.black,
                  ),
                  title: new Text(
                    'Settings',
                    style: TextStyle(
                        // color: Colors.black,
                        ),
                  ),
                  onTap: () {
                  },
                ),
              ],
            ),
          );
        });
  }
}
