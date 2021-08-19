import 'package:flutter/material.dart';
import 'package:skype_clone/enum/view_state.dart';

class VoiceUploadProvider with ChangeNotifier{
  ViewState _viewState=ViewState.IDLE;
  ViewState get getViewState=>_viewState;//state getter

  void setToLoading(){
    _viewState=ViewState.LOADING;
    notifyListeners();
  }
  void setToIdle(){
    _viewState=ViewState.IDLE;
    notifyListeners();
  }
}