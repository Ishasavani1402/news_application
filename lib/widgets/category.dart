// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

List<String> categories = [
  "General",
  "Technology",
  "Sports",
  "Entertainment",
  "Business",
  "Health",
];

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 20,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(10),
                  //   child: Image.network(
                  //     "",
                  //     height: 50,
                  //     width: 100,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 30,
                    child: Text(
                      "Flower",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
