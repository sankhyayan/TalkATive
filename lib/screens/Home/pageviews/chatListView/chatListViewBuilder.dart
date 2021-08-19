import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/contacts.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/chat_methods.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/contact_view.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screens/Home/pageviews/chatListView/widgets/quiet_box.dart';

class ChatListContainer extends StatelessWidget {
  final double defaultSize;
  ChatListContainer({required this.defaultSize});
  final ChatMethods _chatMethods = ChatMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          ///complete snapshot collection
          stream: _chatMethods.fetchContacts(userId: userProvider.getUser.uid!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ///creating list of the snapshot's data
              var docList = snapshot.data!.docs;

              ///contact list
              if (docList.isEmpty) {
                return QuietBox(
                  defaultSize: defaultSize,
                  heading: "All chats",
                  subtitle: "Chat with friends and family",
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(defaultSize),
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    ///passing each data of the snapshot's list as map
                    Contact contact = Contact.fromMap(
                        docList[index].data() as Map<String, dynamic>);
                    return ContactView(
                      defaultSize: defaultSize,
                      contact: contact,
                    );
                  },
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
