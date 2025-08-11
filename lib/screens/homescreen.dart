// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_application/models/Bitcoinmodel.dart';
import 'package:news_application/models/news_headlines.dart';
import 'package:news_application/screens/categoriesScreen.dart';
import 'package:news_application/services/api_services.dart';
import 'package:news_application/widgets/detailed.dart';
import 'package:animate_do/animate_do.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final String _topHeadlinesSource = "bbc-news";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "News",
          style: TextStyle(
            fontFamily: "black",
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white, // Title text color is now white
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.category , color: Colors.white,),
            onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },)
        ],
        backgroundColor: Colors.red.shade500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), // Background color is now red
        elevation: 1, // Subtle elevation
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Search Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  prefixIcon: const Icon(Icons.search, color: Colors.red),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red.shade500),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            // --- Section for Top Headlines ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FadeInLeft(
                child: const Text(
                  "Top Headlines",
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: height * 0.48, // Adjusted height for a cleaner look
              child: FutureBuilder<News_BBC>(
                future: ApiServices.fetch_api(_topHeadlinesSource),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SpinKitPulse(color: Colors.red, size: 50));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                    return const Center(child: Text("No top headlines available."));
                  } else {
                    final filteredArticles = snapshot.data!.articles!
                        .asMap()
                        .entries
                        .where((entry) => _searchQuery.isEmpty ||
                        (entry.value.title?.toLowerCase().contains(_searchQuery) ?? false))
                        .toList();
                    if (filteredArticles.isEmpty) {
                      return const Center(child: Text("No matching headlines found."));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        final entry = filteredArticles[index];
                        final article = entry.value;
                        final originalIndex = entry.key;
                        final formattedDate = DateFormat("MMM dd, yyyy").format(
                          DateTime.parse(article.publishedAt.toString()),
                        );

                        return FadeInRight(
                          delay: Duration(milliseconds: 100 * originalIndex),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => detailed(
                                    image: article.urlToImage ?? '',
                                    discription: article.description ?? 'No description available.',
                                    source: article.source?.name ?? 'Unknown Source',
                                    author: article.author ?? "Unknown Author",
                                    title: article.title ?? 'No Title',
                                    published: formattedDate,
                                    content: article.content ?? 'No content available.',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: width * 0.75,
                              margin: EdgeInsets.only(
                                left: index == 0 ? 16.0 : 8.0,
                                right: 8.0,
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Background Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: article.urlToImage != null
                                        ? CachedNetworkImage(
                                      imageUrl: article.urlToImage!,
                                      height: height * 0.25,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                      const SpinKitFadingCircle(color: Colors.red, size: 25),
                                      errorWidget: (context, url, error) => Container(
                                        height: height * 0.25,
                                        color: Colors.red[50],
                                        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.red, size: 40)),
                                      ),
                                    )
                                        : Container(
                                      height: height * 0.25,
                                      color: Colors.red[50],
                                      child: const Center(child: Icon(Icons.image_not_supported, color: Colors.red, size: 40)),
                                    ),
                                  ),
                                  // Text Content
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title ?? 'No Title',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          article.source?.name ?? 'Unknown Source',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
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
            const SizedBox(height: 24),
            // --- Section for Bitcoin News ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FadeInLeft(
                child: const Text(
                  "All about Bitcoins",
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Bitcoin>(
              future: ApiServices.fetch_api_bitcoim(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SpinKitPulse(color: Colors.red, size: 50));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                  return const Center(child: Text("No Bitcoin news available."));
                } else {
                  final filteredArticles = snapshot.data!.articles!
                      .asMap()
                      .entries
                      .where((entry) => _searchQuery.isEmpty ||
                      (entry.value.title?.toLowerCase().contains(_searchQuery) ?? false))
                      .toList();
                  if (filteredArticles.isEmpty) {
                    return const Center(child: Text("No matching Bitcoin news found."));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final entry = filteredArticles[index];
                      final article = entry.value;
                      final originalIndex = entry.key;
                      final formattedDate = DateFormat("MMM dd, yyyy").format(
                        DateTime.parse(article.publishedAt.toString()),
                      );

                      return SlideInUp(
                        duration: Duration(milliseconds: 300 + originalIndex * 50),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => detailed(
                                  image: article.urlToImage ?? '',
                                  discription: article.description ?? 'No description available.',
                                  source: article.source?.name ?? 'Unknown Source',
                                  author: article.author ?? "Unknown Author",
                                  title: article.title ?? 'No Title',
                                  published: formattedDate,
                                  content: article.content ?? 'No content available.',
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
                                children: [
                                  // News Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: article.urlToImage != null
                                        ? CachedNetworkImage(
                                      imageUrl: article.urlToImage!,
                                      width: width * 0.25,
                                      height: width * 0.2,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                      const SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: SpinKitFadingCircle(color: Colors.red, size: 20),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: width * 0.25,
                                        height: width * 0.2,
                                        color: Colors.red[50],
                                        child: const Icon(Icons.image_not_supported, color: Colors.red),
                                      ),
                                    )
                                        : Container(
                                      width: width * 0.25,
                                      height: width * 0.2,
                                      color: Colors.red[50],
                                      child: const Icon(Icons.image_not_supported, color: Colors.red),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // News Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              article.source?.name ?? 'Unknown Source',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.visible,
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
                        ),
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}