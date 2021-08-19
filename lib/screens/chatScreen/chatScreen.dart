import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/enum/view_state.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/sizeConfig.dart';
import 'package:skype_clone/models/userData.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/provider/voiceUploadProvider.dart';
import 'package:skype_clone/resources/chat_methods.dart';
import 'package:skype_clone/resources/storage_methods.dart';
import 'package:skype_clone/screens/callScreens/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/chatScreen/widgets/cached_image.dart';
import 'package:skype_clone/utils/call_utilities.dart';
import 'package:skype_clone/utils/permissions.dart';
import 'package:skype_clone/utils/sound_player.dart';
import 'package:skype_clone/utils/sound_recorder.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/utils/utilities.dart';
import 'package:skype_clone/widgets/appBar.dart';
import 'package:skype_clone/widgets/chatScreenBottomModalPage.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserData receiver, currentUser;
  ChatScreen({required this.receiver, required this.currentUser});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _listScrollController = ScrollController();
  FocusNode textFieldFocus = FocusNode();
  ImageUploadProvider imageUploadProvider = ImageUploadProvider();
  VoiceUploadProvider voiceUploadProvider = VoiceUploadProvider();
  bool showEmojiPicker = false;
  bool isWriting = false;
  bool isScrollLast = true;
  bool downButtonShow = false;
  Icon notRecording = Icon(Icons.mic_none);
  Icon recording = Icon(
    Icons.mic_rounded,
    color: Colors.lightBlueAccent,
  );
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    voiceUploadProvider = Provider.of<VoiceUploadProvider>(context);
    SizeConfig().init(context);
    final defaultSize = SizeConfig.defaultSize;
    return PickupLayout(
      defaultSize: defaultSize,
      scaffold: Scaffold(
        backgroundColor: Colors.black,
        appBar: customAppBar(context, defaultSize),
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: messageList(defaultSize),
                ),
                imageUploadProvider.getViewState == ViewState.LOADING
                    ? Container(
                        margin: EdgeInsets.only(right: defaultSize * 1.5),
                        alignment: Alignment.centerRight,
                        child: CircularProgressIndicator(
                          color: UniversalVariables.gradientColorStart,
                        ),
                      )
                    : Container(),
                voiceUploadProvider.getViewState == ViewState.LOADING
                    ? Container(
                        width: MediaQuery.of(context).size.width * .4,
                        margin: EdgeInsets.only(
                            right: defaultSize * 1.1, left: defaultSize * 25),
                        alignment: Alignment.bottomRight,
                        child: LinearProgressIndicator(
                          color: UniversalVariables.gradientColorStart,
                        ),
                      )
                    : Container(),
                chatControls(defaultSize, context),
                showEmojiPicker
                    ? Container(child: emojiContainer(defaultSize))
                    : Container(),
              ],
            ),
            isScrollLast == false
                ? Positioned(
                    right: defaultSize * 18.5,
                    bottom: defaultSize * 8,
                    child: IconButton(
                      splashRadius: defaultSize,
                      onPressed: () async {
                        await Future.delayed(Duration(milliseconds: 200));
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          _listScrollController.animateTo(
                              _listScrollController.position.minScrollExtent,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        });
                      },
                      color: Colors.white,
                      icon: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: defaultSize * 3.2,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  CustomAppBar customAppBar(context, double defaultSize) {
    return CustomAppBar(
        color: UniversalVariables.gradientColorEnd,
        title: Text(
          widget.receiver.name!,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: widget.currentUser,
                        to: widget.receiver,
                        context: context)
                    : {},
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
        defaultSize: defaultSize);
  } //custom chat screen app bar

  Widget chatControls(double defaultSize, BuildContext context) {
    bool isRecording = recorder.isRecording;
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(defaultSize),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => addMediaModel(defaultSize, context),
            child: Container(
              padding: EdgeInsets.all(defaultSize * .5),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: defaultSize * .5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  maxLines: null,
                  focusNode: textFieldFocus,
                  controller: _textEditingController,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(color: Colors.white),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type Message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: isWriting ? BorderSide() : BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(defaultSize * 5),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                        top: defaultSize * .5,
                        bottom: defaultSize * .5,
                        right: defaultSize * 3.5,
                        left: defaultSize * 2),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.emoji_emotions_outlined),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultSize),
                  child: IconButton(
                    onPressed: () async => await recordSound(),
                    icon: isRecording ? recording : notRecording,
                  )),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: () async {
                    await Permissions.cameraAndMicrophonePermissionsGranted();
                    await pickImage(source: ImageSource.camera);
                  },
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: defaultSize),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: defaultSize * 1.8,
                    ),
                    onPressed: () => sendMessage(defaultSize),
                  ),
                )
              : Container(),
        ],
      ),
    );
  } //chat send , video call, call etc. buttons

  Widget messageList(double defaultSize) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(MESSAGES_COLLECTION)
          .doc(widget.currentUser.uid)
          .collection(widget.receiver.uid!)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              color: UniversalVariables.lightBlueColor,
            ),
          );
        }
        return NotificationListener<ScrollUpdateNotification>(
          child: ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            controller: _listScrollController,
            itemBuilder: (context, index) {
              return chatMessageItem(
                  defaultSize, snapshot.data!.docs[index], index);
            },
          ),
          onNotification: (notification) {
            if (notification.metrics.pixels > 135) {
              if (downButtonShow == false) {
                setState(() {
                  isScrollLast = false;
                  downButtonShow = true;
                });
              }
            } else {
              if (downButtonShow == true) {
                setState(() {
                  isScrollLast = true;
                  downButtonShow = false;
                });
              }
            }
            return true;
          },
        );
      },
    );
  } //ListView Builder to build from a stream of messages

  Widget chatMessageItem(
      double defaultSize, DocumentSnapshot snapshot, int index) {
    Map<String, dynamic> _data = snapshot.data() as Map<String, dynamic>;
    Message _message = Message.fromMap(_data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultSize * .4),
      child: Container(
        alignment: _message.senderId == widget.currentUser.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == widget.currentUser.uid
            ? senderLayout(defaultSize, _message, index)
            : receiverLayout(defaultSize, _message, index),
      ),
    );
  } //Chat box builder

  Widget senderLayout(double defaultSize, Message message, int index) {
    Radius messageRadius = Radius.circular(defaultSize);
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(defaultSize),
        child: getMessage(defaultSize, message, index),
      ),
    );
  }

  Widget receiverLayout(double defaultSize, Message message, int index) {
    Radius messageRadius = Radius.circular(defaultSize);
    return Container(
      margin: EdgeInsets.only(top: defaultSize * 1.2),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(defaultSize),
        child: getMessage(defaultSize, message, index),
      ),
    );
  }

  //+ icon to icon show bottom modal sheet
  addMediaModel(double defaultSize, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: defaultSize * 1.5),
                child: Row(
                  children: [
                    FlatButton(
                      onPressed: () => Navigator.maybePop(context),
                      child: Icon(
                        Icons.close,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and Tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: defaultSize * 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: [
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Video",
                      icon: Icons.image,
                      onTap: () => pickImage(source: ImageSource.gallery),
                      defaultSize: defaultSize,
                    ),
                    ModalTile(
                      title: "File",
                      subtitle: "Share files",
                      icon: Icons.tab,
                      onTap: () {},
                      defaultSize: defaultSize,
                    ),
                    ModalTile(
                      title: "Contact",
                      subtitle: "Share contacts",
                      icon: Icons.contacts,
                      onTap: () {},
                      defaultSize: defaultSize,
                    ),
                    ModalTile(
                      title: "Location",
                      subtitle: "Share a location",
                      icon: Icons.add_location,
                      onTap: () {},
                      defaultSize: defaultSize,
                    ),
                    ModalTile(
                      title: "Schedule Call",
                      subtitle: "Arrange a skype call and get reminders",
                      icon: Icons.schedule,
                      onTap: () {},
                      defaultSize: defaultSize,
                    ),
                    ModalTile(
                      title: "Create Poll",
                      subtitle: "Share polls",
                      icon: Icons.poll,
                      onTap: () {},
                      defaultSize: defaultSize,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        elevation: 0,
        backgroundColor: Colors.black);
  }

  sendMessage(double defaultSize) {
    String text = _textEditingController.text;
    Message _message = Message(
      senderId: widget.currentUser.uid!,
      receiverId: widget.receiver.uid!,
      type: "text",
      message: text,
      photoUrl: "",
      timestamp: Timestamp.now(),
    );
    setState(() {
      isWriting = false;
    });
    _textEditingController.clear();
    _chatMethods.addMessageToDb(_message, widget.currentUser, widget.receiver);
  }

  getMessage(double defaultSize, Message message, int index) {
    if (message.type == MESSAGE_TYPE_TEXT) {
      return Text(
        message.message!,
        style: TextStyle(color: Colors.white, fontSize: defaultSize * 1.6),
      );
    }
    if (message.type == MESSAGE_TYPE_IMAGE) {
      if (message.photoUrl != null) {
        return CachedImage(
          imageUrl: message.photoUrl!,
          height: defaultSize * 25,
          width: defaultSize * 25,
          radius: 10,
        );
      } else {
        return Text("Image Error");
      }
    }
    if (message.type == MESSAGE_TYPE_VOICE) {
      if (message.photoUrl != null) {
        bool isPlaying = player.isPlaying;
        return Container(
          height: defaultSize * 4,
          width: defaultSize * 25,
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  return await playSound(url: message.photoUrl!, index: index);
                },
                child: ((selectedIndex == index) && isPlaying)
                    ? Icon(
                        Icons.pause,
                        color: Colors.lightBlueAccent,
                        size: defaultSize * 3,
                      )
                    : Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: defaultSize * 3,
                      ),
              ),
              SizedBox(
                width: defaultSize,
              ),
              isPlaying
                  ? Container(
                      constraints: BoxConstraints(maxWidth: defaultSize * 20.25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: LinearProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : Container(
                      constraints: BoxConstraints(
                          maxWidth: defaultSize * 20.25, maxHeight: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[700],
                      ),
                    ),
            ],
          ),
        );
      } else {
        return Text("Voice Error");
      }
    }
  }

  emojiContainer(double defaultSize) {
    return Expanded(
      flex: MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 1,
      child: EmojiPicker(
        onBackspacePressed: () {
          hideEmojiContainer();
        },
        onEmojiSelected: (category, emoji) {
          setState(() {
            isWriting = true;
          });
          _textEditingController.text += emoji.emoji;
        },
        config: Config(
          bgColor: Color(0xff272c35),
          indicatorColor: Color(0xff2b9ed4),
          columns: 7,
        ),
      ),
    );
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  pickImage({required ImageSource source}) async {
    File? selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: selectedImage!,
        receiverId: widget.receiver.uid!,
        senderId: widget.currentUser.uid!,
        imageUploadProvider: imageUploadProvider);
  }

  recordSound() async {
    await recorder.toggleRecording();
    await recorder.uploadAudioFile(
      voiceUploadProvider: voiceUploadProvider,
      senderId: widget.currentUser.uid!,
      receiverId: widget.receiver.uid!,
    );
    setState(() {});
  }

  playSound({required String url, required int index}) async {
    await player.togglePlaying(whenFinished: () => setState(() {}), url: url);
    setState(() {
      selectedIndex = index;
    });
  }
}
