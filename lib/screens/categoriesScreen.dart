// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_application/models/categorymodel.dart';
import 'package:news_application/services/api_services.dart';

import 'detaildscreen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

List<String> categories = [
  "General",
  "Technology",
  "Sports",
  "Entertainment",
  "Business",
  "Health",
];

class _CategoriesState extends State<CategoriesScreen> {
  String categoryname = "General";
  Future<CategoryModel> fetchdata() async {
    final response = await ApiServices.fetch_api_category(categoryname);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height * 1;
    var width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories",style: TextStyle(fontFamily: "black",fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          categoryname = categories[index];
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              categoryname == categories[index]
                                  ? Colors.grey
                                  : Colors.black,
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
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<CategoryModel>(
              future: ApiServices.fetch_api_category(categoryname),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitCircle(color: Colors.blue));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime now = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      final formate = DateFormat("dd.MM.yy");
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => detaildscreen(
                                    imgsource:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .urlToImage!
                                            .toString(),
                                    title:
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                    source:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .source!
                                            .name
                                            .toString(),
                                    datetime:
                                    formate.format( DateTime.parse(
                                      snapshot.data!.articles![index].publishedAt.toString(),
                                    )),
                                    discription:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .description!,
                                    content:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .content!,
                                    author:
                                        snapshot.data!.articles![index].author ?? "unknown",
                                  ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: height * .15,
                                  width: width * .22,
                                  imageUrl:
                                      snapshot.data!.articles![index].urlToImage
                                          .toString(),
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => SizedBox(
                                        child: SpinKitCircle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),
                            SizedBox(width: width * .03),
                            SizedBox(
                              width: width * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // textAlign: TextAlign.justify,
                                    snapshot.data!.articles![index].title!,
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: height * .05),
                                  Row(
                                    children: [
                                      Text(
                                        snapshot
                                                    .data!
                                                    .articles![index]
                                                    .source!
                                                    .name
                                                    .toString()
                                                    .length >
                                                5
                                            ? '${snapshot.data!.articles![index].source!.name!.substring(0, 5)}...'
                                            : snapshot
                                                .data!
                                                .articles![index]
                                                .source!
                                                .name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "regular",
                                        ),
                                      ),
                                      SizedBox(width: width * .2),
                                      Text(formate.format(now)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
