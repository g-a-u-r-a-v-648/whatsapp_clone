import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_app_clone/core/images/const_images.dart';
import 'package:whats_app_clone/prsentation/chat_screen/ui/chat_screen.dart';
import 'package:whats_app_clone/prsentation/user_list/ui/user_model/user_model.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool showLoader = true;
  List<UserDataModel> userDataList = <UserDataModel>[];

//  List of all Conversation

  loadList() {
    userDataList.clear();
    List<UserDataModel> loadList = <UserDataModel>[
      UserDataModel(
          name: 'Abhishek',
          image: NetworkImages.networkImage1,
          message: "No Message yet",
          chatMessageString: ChatMessageString.chatMessageString),
      UserDataModel(
          name: "Divyansh",
          image: NetworkImages.networkImage2,
          message: "No Message yet",
          chatMessageString: ChatMessageString.chatMessageString),
      UserDataModel(
          name: "Gaurav Bhradwaj",
          image: NetworkImages.networkImage3,
          message: "No Message yet",
          chatMessageString: ChatMessageString.chatMessageString)
    ];
    setState(() {});
    userDataList.addAll(loadList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:


      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          userDataList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.h),
                      itemCount: userDataList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            userdata: userDataList[index],
                                          )));
                                },
                                child: userList(index, userDataList)),
                          ],
                        );
                      }),
                )
              : InkWell(
                  onTap: () {
                    loadList();
                  },
                  child: Container(
                    height: 50.h,
                    alignment: Alignment.center,
                    child: Text(
                      "Click to load list of conversation",
                      style: TextStyle(
                          color: const Color(0xff075E54),
                          fontSize: 16.sp,
                          decoration: TextDecoration.underline,
                          height: 2),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget userList(int index, List<UserDataModel> userData) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.h),
        height: 70.h,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipOval(
              child: Container(
                height: 50.h,
                width: 58.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  userData[index].image.toString(),
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
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200.w,
                  child: Text(
                    userData[index].name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 19.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 200.w,
                  child: Text(
                    userData[index].message.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "Today",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}
