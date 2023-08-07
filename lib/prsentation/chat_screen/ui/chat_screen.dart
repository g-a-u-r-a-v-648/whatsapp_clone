import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whats_app_clone/prsentation/chat_screen/ui/chat_model/chat_model.dart';

import '../../../core/images/const_images.dart';
import '../../user_list/ui/user_model/user_model.dart';

class ChatScreen extends StatefulWidget {
  UserDataModel userdata;

  ChatScreen({Key? key, required this.userdata}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  File? cameraImage;
  TextEditingController messageController = TextEditingController();
  List<ChatModel> messagesList = [];
  String? message;
  int index = 0;
  double height = 0;

  bool isShowIcons = true;
  bool isShowPicker = true;

  // pick image from Camera

  pickImageCamera() async {
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo == null) {
        return;
      }
      final imageTemp = File(photo.path);
      setState(() {
        cameraImage = imageTemp;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _saveMessages() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/chat_messages.json');
    final jsonData = json.encode(messagesList.map((m) => m.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  // Send message

  sendMessage() async {
    // This is for current time

    String currentTime = DateFormat("hh:mm a").format(DateTime.now());
    print(currentTime);
    message = messageController.text.trim().toString();
    if (message!.isNotEmpty) {
      final chatModel = ChatModel(
          message: message,
          user: "You",
          timestamp: currentTime,
          image: cameraImage);
      messagesList.add(chatModel);
      setState(() {
        messageController.clear();
        _saveMessages();
      });
      Timer(
          const Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    }
  }

  // Load old messages of user

  Future<void> _loadMessages() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.userdata.chatMessageString}');

    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final messagesJson = json.decode(jsonData);
      setState(() {
        messagesList = List<ChatModel>.from(
            messagesJson.map((m) => ChatModel.fromJson(m)));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        isShowPicker = true;
        setState(() {});
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 55.h,
          flexibleSpace: Container(
            height: 90.h,
            color: const Color(0xff075E54),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 5.w,
                      ),
                      ClipOval(
                        child: Container(
                          height: 45.h,
                          width: 50.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            widget.userdata.image.toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  color: Colors.amber,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    ImagesHelper.errorImg,
                                    fit: BoxFit.cover,
                                  ));
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.userdata.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Icon(Icons.camera_alt_outlined,
                          color: Colors.white),
                      SizedBox(
                        width: 18.w,
                      ),
                      const Icon(Icons.search, color: Colors.white),
                      SizedBox(
                        width: 18.w,
                      ),
                      Image.asset(
                        ImagesHelper.menuIcon,
                        height: 18.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagesHelper.chatBackGround),
                  fit: BoxFit.cover)),
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                left: 0.w,
                bottom: 0,
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(bottom: 60.h),
                  height: size.height,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      controller: _scrollController,
                      itemCount: messagesList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.bottomRight,
                                child: userMessage(index)),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        );
                      }),
                ),
              ),
              isShowPicker == true
                  ? const SizedBox()
                  : Positioned(
                      bottom: 70, left: 0, right: 0, child: showBottomSheet()),
              Positioned(left: 0, right: 0, bottom: 0, child: sendButton())
            ],
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return Container(
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0.r),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 1), blurRadius: 1, color: Colors.grey)
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesHelper.smileIcon,
                    color: Colors.grey,
                    height: 17.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      controller: messageController,
                      maxLines: null,
                      onChanged: (messageControllers) {
                        if (messageController.text.trim().isEmpty) {
                          isShowIcons = true;
                          setState(() {});
                        } else {
                          isShowIcons = false;
                          setState(() {});
                        }
                      },
                      onSubmitted: (v) {
                        if (messageController.text.trim().isEmpty) {
                          isShowIcons = true;

                          setState(() {});
                        } else {
                          isShowIcons = false;
                          setState(() {});
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: "Type Message...",
                          border: InputBorder.none),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          height = 150.h;
                          isShowPicker = !isShowPicker;

                          setState(() {});
                        },
                        child: Image.asset(
                          ImagesHelper.paperClip,
                          color: Colors.black45,
                          height: 17.h,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      isShowIcons == true
                          ? Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5.r),
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle),
                                    child: Image.asset(
                                      ImagesHelper.rupeeIcon,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  width: 25.w,
                                ),
                                const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black45,
                                )
                              ],
                            )
                          : const SizedBox()
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 15.w),
          isShowIcons == true
              ? Container(
                  padding: EdgeInsets.all(12.0.r),
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: Icon(
                    Icons.keyboard_voice,
                    color: Colors.white,
                    size: 16.h,
                  ),
                )
              : InkWell(
                  onTap: () {
                    setState(() {});

                    sendMessage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0.r),
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16.h,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget userMessage(int index) {
    return messagesList[index].message != ""
        ? Container(
            margin: EdgeInsets.only(left: 80.w, right: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: const Color(0xffDCF7C5),
            ),
            padding: EdgeInsets.all(10.r),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        messagesList[index].message.toString(),
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      messagesList[index].timestamp.toString(),
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.black45, fontSize: 10.sp),
                    ),
                  ],
                ),
                messagesList[index].image == null
                    ? const SizedBox()
                    : Container(
                        height: 80.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: const Color(0xffDCF7C5),
                        ),
                        child: Image.file(
                          messagesList[index].image!,
                          fit: BoxFit.cover,
                        ),
                      )
              ],
            ),
          )
        : const SizedBox();
  }

  Widget showBottomSheet() {
    return
        // showModalBottomSheet(context: context, builder: (context){
        AnimatedContainer(
      curve: isShowPicker ? Curves.bounceIn : Curves.bounceOut,
      height: height,
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 35.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r), color: Colors.white),
      duration: const Duration(seconds: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20.w,
        children: [
          Column(
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.withOpacity(0.8),
                ),
                child: Image.asset(
                  ImagesHelper.documentsImg,
                  color: Colors.white,
                ),
              ),
              Text(
                "Documents",
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
              )
            ],
          ),
          InkWell(
            onTap: () {
              print("object");
              pickImageCamera();
            },
            child: Column(
              children: [
                Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink.withOpacity(0.8)),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Camera",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                )
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent.withOpacity(0.8)),
                child: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ),
              Text(
                "Gallery",
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
              )
            ],
          ),
        ],
      ),
    );
    // });
  }
}
