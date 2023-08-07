import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  bool isLoader;
  Loader({Key? key, required this.isLoader}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  void initState() {
    super.initState();
    widget.isLoader = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          widget.isLoader == false
              ? const SizedBox()
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.green,
                ))
        ],
      ),
    );
  }
}
