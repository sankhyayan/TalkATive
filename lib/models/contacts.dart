import 'package:cloud_firestore/cloud_firestore.dart';

class Contact{
  String? uid="";
  Timestamp addedOn=Timestamp.now();
  Contact({required this.uid,required this.addedOn});
  Map<String,dynamic> toMap(Contact contact){
    var data=Map<String,dynamic>();
    data['contact_id']=contact.uid;
    data['added_on']=contact.addedOn;
    return data;
  }
  Contact.fromMap(Map<String,dynamic>mapData){
    this.uid=mapData['contact_id'];
    this.addedOn=mapData['added_on'];
  }
}