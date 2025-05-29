import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class detaildscreen extends StatefulWidget{
  
  String imgsource;
  String title;
  String source;
  String datetime;
  
  detaildscreen({
    required this.imgsource,
    required this.title,
    required this.source,
    required this.datetime,
  });
  @override
  State<StatefulWidget> createState() => _detaildscreenState();
}

class _detaildscreenState extends State<detaildscreen>{

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height *1;
    var width = MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(imageUrl: widget.imgsource)),
          SizedBox(height: height * .04,),
          Container(
            color: Colors.grey,
          )

        ],
      ),
    );
  }
}