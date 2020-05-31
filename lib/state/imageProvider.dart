import 'package:flutter/cupertino.dart';

enum View{
  Loading,
  Idle
}


class ImageServiceProvider with ChangeNotifier{
  View _view = View.Idle;
  View get getView => _view;

  void setToLoading(){
    _view = View.Loading;
    notifyListeners();
  }

  void setToIdle(){
    _view = View.Idle;
    notifyListeners();
  }
}