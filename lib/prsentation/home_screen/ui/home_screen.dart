import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_app_clone/core/images/const_images.dart';

import '../../user_list/ui/user_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync:this );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.h,
        flexibleSpace: Container(

          height: 120.h,
          color:const Color(0xff075E54),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 30.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(

                  children: [
                    Text(
                      "WhatApp",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.camera_alt_outlined,color: Colors.white),
                    SizedBox(width: 18.w,),
                    const Icon(Icons.search,color: Colors.white),
                    SizedBox(width: 18.w,),
                    Image.asset(
                        ImagesHelper.menuIcon,height: 18.h,color: Colors.white,),
                  ],
                ),
              ),
              TabBar(
                controller: tabController,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  SizedBox(
                    height: 30.h,
                    child: Center(
                      child: Text(
                        "Chats",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: Center(
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: Center(
                      child: Text(
                        "Calls",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: TabBarView(
          controller: tabController,
          children: const [
            UserList(),
          Center(child: Text("Under Development")),
          Center(child: Text("Under Development")),
        ],

        ),
      ),
    );
  }
}
