// ignore_for_file: must_be_immutable, camel_case_types, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class detaildscreen extends StatefulWidget {
  String imgsource;
  String title;
  String source;
  String datetime;
  String discription;
  String content;
  String author;

  detaildscreen({
    required this.imgsource,
    required this.title,
    required this.source,
    required this.datetime,
    required this.discription,
    required this.content,
    required this.author,
  });
  @override
  State<StatefulWidget> createState() => _detaildscreenState();
}

class _detaildscreenState extends State<detaildscreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height * 1;
    var width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "DetailedNews",
          style: TextStyle(fontFamily: "black", fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: CachedNetworkImage(
                // height: height*.15,
                // width: width *1,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Center(
                      child: Center(
                        child: SpinKitChasingDots(color: Colors.black),
                      ),
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageUrl: widget.imgsource,
              ),
            ),
            SizedBox(height: height*.04,),
            RichText(text: TextSpan(children: [
              TextSpan(text: "AUthor name : ", style: TextStyle(fontSize: 20, fontFamily: "bold",color: Colors.black)),
              TextSpan(text: widget.author, style: TextStyle(fontSize: 20, fontFamily: "regular",color: Colors.black)),
            ]
            )),
            SizedBox(height: height * .04),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontFamily: "black"),
            ),
            SizedBox(height: height * .04),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.discription,
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: "regular", fontSize: 15),
              ),
            ),
            SizedBox(height: height * .04),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.content,
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: "regular", fontSize: 15),
              ),
            ),
            SizedBox(height: height * .02),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(children: [
                Expanded(
                  child: RichText(text: TextSpan(children: [
                    TextSpan(text: "Source : ", style: TextStyle(fontSize: 20, fontFamily: "regular",color: Colors.black)),
                    TextSpan(text: widget.source, style: TextStyle(fontSize: 18, fontFamily: "bold",color: Colors.black)),
                  ]
                  )),
                ),
                Expanded(
                  child: RichText(text: TextSpan(children: [
                    TextSpan(text: "Published at : ", style: TextStyle(fontSize: 18, fontFamily: "regular",color: Colors.black)),
                    TextSpan(text: widget.datetime, style: TextStyle(fontSize: 15, fontFamily: "bold",color: Colors.black)),
                  ]
                  )),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
