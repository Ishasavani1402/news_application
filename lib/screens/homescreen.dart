// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api,
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_application/models/news_headlines.dart';
import 'package:news_application/screens/categoriesScreen.dart';
import 'package:news_application/services/api_services.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

enum FilterList { bbcnews, arynews, independent, cnn }

FilterList? selectedvalue;

class _HomescreenState extends State<Homescreen> {
  // List<News_BBC> artical = [];

  Future<News_BBC> fetchdata() async {
    final response = await ApiServices.fetch_api(name);
    return response;
  }

  String name = "bbc-news";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "News",
          style: TextStyle(fontFamily: "black", fontSize: 20),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },
          child: Icon(Icons.category),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            onSelected: (FilterList iteam) {
              setState(() {
                selectedvalue = iteam;
                if (FilterList.bbcnews.name == iteam.name) {
                  name = "bbc-news";
                }
                if (FilterList.arynews.name == iteam.name) {
                  name = "ary-news";
                }
              });
            },
            initialValue: selectedvalue,
            itemBuilder:
                (context) => <PopupMenuEntry<FilterList>>[
                  PopupMenuItem<FilterList>(
                    value: FilterList.bbcnews,
                    child: Text("BBc-news"),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.arynews,
                    child: Text("ary-news"),
                  ),
                ],
          ),
        ],
      ),
      body: ListView(
        // scrollDirection: Axis.vertical,
        children: [
          SizedBox(
            height: height * 0.5,
            width: width,
            child: FutureBuilder<News_BBC>(
              future: ApiServices.fetch_api(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitCircle(color: Colors.blue));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime now = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      final formate = DateFormat("dd.MM.yy");
                      return SizedBox(
                        child: Stack(
                          children: [
                            SizedBox(
                              height: height * 0.5,
                              width: width * .9,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .urlToImage
                                            .toString(),
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => SizedBox(
                                          child: SpinKitCircle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Card(
                                elevation: 1,
                                surfaceTintColor: Colors.black45,
                                shadowColor: Colors.black,
                                color: Colors.white,
                                child: SizedBox(
                                  // alignment: Alignment.bottomCenter,
                                  height: height * .32,
                                  // width: width * .55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * .7,
                                          child: Text(
                                            snapshot
                                                .data!
                                                .articles![index]
                                                .description!,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "bold",
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!
                                                  .articles![index]
                                                  .source!
                                                  .name
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "bold",
                                              ),
                                            ),
                                            Text(
                                              formate.format(now),
                                              style: TextStyle(
                                                fontFamily: "bold",
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
