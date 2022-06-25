import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  AppBarWidget({required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B1D1F),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBar(
            backgroundColor: const Color(0xFF1B1D1F),
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Text(title),
            centerTitle: true,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
              color: Colors.white,
            ),
            height: 15,
          )
        ],
      ),
    );
  }
}
