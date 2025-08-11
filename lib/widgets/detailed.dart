// ignore_for_file: must_be_immutable, camel_case_types, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Google Fonts package

class detailed extends StatefulWidget {
  String image;
  String discription;
  String source;
  String author;
  String title;
  String published;
  String content;

  detailed({
    required this.image,
    required this.discription,
    required this.source,
    required this.author,
    required this.title,
    required this.published,
    required this.content,
  });

  @override
  State<StatefulWidget> createState() => _detailedState();
}

class _detailedState extends State<detailed> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: const Text(
          "Detailed News",
          style: TextStyle(
            fontFamily: "black",
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with a subtle shadow
            Container(
              height: height * 0.35,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.image,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: SpinKitFadingCircle(color: Colors.red, size: 50),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.red.shade50,
                    child: const Icon(Icons.image_not_supported, color: Colors.red, size: 50),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.03),

            // News Title with Google Font
            Text(
              widget.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: height * 0.015),

            // Author and Published Date with Google Font
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Author: ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        TextSpan(
                          text: widget.author,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Published: ${widget.published}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),

            // Description with Google Font
            const Divider(color: Colors.red, thickness: 1.5),
            SizedBox(height: height * 0.02),
            Text(
              widget.discription,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 17,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: height * 0.03),

            // Content with Google Font
            Text(
              widget.content,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 17,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: height * 0.03),

            // Source with Google Font
            const Divider(color: Colors.red, thickness: 1.5),
            SizedBox(height: height * 0.02),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Source: ",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: widget.source,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}