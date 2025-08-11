// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_application/models/categorymodel.dart';
import 'package:news_application/services/api_services.dart';
import 'package:news_application/widgets/detailed.dart';

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Light grey background
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Category Screen",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
      ),
      body: Column(
        children: [
          // --- Category Tabs Section ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          categoryname = categories[index];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: categoryname == categories[index]
                              ? Colors.red.shade500 // Active tab color
                              : Colors.grey.shade200, // Inactive tab color
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: categoryname == categories[index]
                                ? Colors.red.shade500
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categories[index].toString(),
                            style: GoogleFonts.poppins(
                              color: categoryname == categories[index]
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: categoryname == categories[index]
                                  ? FontWeight.bold
                                  : FontWeight.w500,
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
          // --- News List Section ---
          Expanded(
            child: FutureBuilder<CategoryModel>(
              future: fetchdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SpinKitFadingCircle(color: Colors.red, size: 50));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
                  return const Center(child: Text("No news available for this category."));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];
                      final formattedDate = DateFormat("dd.MM.yy").format(
                        DateTime.parse(article.publishedAt.toString()),
                      );

                      // Check for null values to prevent errors
                      if (article.title == null || article.description == null) {
                        return const SizedBox.shrink(); // Hide the item if essential data is missing
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailed(
                                image: article.urlToImage ?? '',
                                title: article.title!,
                                source: article.source?.name ?? 'Unknown Source',
                                published: formattedDate,
                                discription: article.description!,
                                content: article.content ?? 'No content available.',
                                author: article.author ?? "Unknown Author",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // News Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    height: width * 0.25,
                                    width: width * 0.25,
                                    imageUrl: article.urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: width * 0.25,
                                      width: width * 0.25,
                                      color: Colors.grey.shade200,
                                      child: const SpinKitFadingCircle(color: Colors.red, size: 25),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      height: width * 0.25,
                                      width: width * 0.25,
                                      color: Colors.red.shade50,
                                      child: const Icon(Icons.image_not_supported, color: Colors.red),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.04),
                                // News Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              article.source?.name ?? 'Unknown Source',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Text(
                                            formattedDate,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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