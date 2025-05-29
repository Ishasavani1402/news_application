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
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    // vertical: 10,
                  ),
                  child: Center(
                    child: Text(
                      categories[index].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "bold",
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
