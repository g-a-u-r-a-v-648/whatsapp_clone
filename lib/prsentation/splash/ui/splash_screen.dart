import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_app_clone/core/images/const_images.dart';
import 'package:whats_app_clone/prsentation/home_screen/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreen();
  }


// Method for Splash screen


  splashScreen() async {
 await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Container(
              height: 70.h,
              width: 70.w,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImagesHelper.whatsAppLogo),
                      fit: BoxFit.cover)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "from",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagesHelper.metaLogo,
                      height: 25.h,
                      width: 28.w,
                      color: const Color.fromARGB(255, 72, 201, 77),
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "Meta",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color.fromARGB(255, 72, 201, 77),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.h,),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
