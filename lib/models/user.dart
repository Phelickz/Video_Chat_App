class User {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  User({
    this.uid,
    this.email,
    this.name,
    this.profilePhoto,
    this.state,
    this.status,
    this.username,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data['status'] = user.status;
    data['state'] = user.state;
    data['photoUrl'] = user.profilePhoto;
    return data;
  }

  User.fromMap(Map<String, dynamic> doc) {
    this.uid = doc['uid'];
    this.name = doc['name'];
    this.email = doc['email'];
    this.username = doc['username'];
    this.status = doc['status'];
    this.state = doc['state'];
    this.profilePhoto = doc['photoUrl'];
  }
}
