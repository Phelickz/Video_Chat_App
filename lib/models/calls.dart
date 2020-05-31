class Call {
  String callerID;
  String callerName;
  String callerPic;
  String receiverID;
  String receiverName;
  String receiverPic;
  String channelID;
  bool dialler;

  Call({
    this.callerID,
    this.callerName,
    this.callerPic,
    this.receiverID,
    this.receiverName,
    this.receiverPic,
    this.channelID,
    this.dialler,
  });

  Map<String, dynamic> toMap(Call call){
    Map<String, dynamic> map = Map();
    map['callerId'] = call.callerID;
    map['callerName'] = call.callerName;
    map['callerPic'] = call.callerPic;
    map['receiverID'] = call.receiverID;
    map['receiverName'] = call.receiverName;
    map['receiverPic'] = call.receiverPic;
    map['channelID'] = call.channelID;
    map['dialler'] = call.dialler;
    return map;
  }

  Call.fromMap(Map map){
    this.callerID = map['callerID'];
    this.callerName = map['callerName'];
    this.callerPic = map['callerPic'];
    this.receiverID = map['receiverID'];
    this.receiverName = map['receiverName'];
    this.receiverPic = map['receiverPic'];
    this.channelID = map['channelID'];
    this.dialler = map['dialler'];
  }
}
