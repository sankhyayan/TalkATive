//CLASS TO MAP DATA INTO FIREBASE
class UserData {
  String? uid="";
  String? name="";
  String? email="";
  String? username="";
  String? status="";
  int state=0;
  String? profilePhoto="";

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.status,
    required this.state,
    required this.profilePhoto,
  });

  Map<String, dynamic> toMap(UserData user) {
    Map<String,dynamic> data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    return data;
  }

  UserData.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }
}