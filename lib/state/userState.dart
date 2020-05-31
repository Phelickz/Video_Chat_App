

import 'package:flutter/cupertino.dart';
import 'package:video_chat/models/user.dart';

class UserNotifier with ChangeNotifier{
  List<User> _userProfileData = [];

  User _currentUser;

  List<User> get userProfileData => _userProfileData;

  User get currentUser => _currentUser;


  set userProfileData(List<User> userProfileData) {
    _userProfileData = userProfileData;
    notifyListeners();
  }

  set currentUser(User user){
    _currentUser = user;
    notifyListeners();
  }
}