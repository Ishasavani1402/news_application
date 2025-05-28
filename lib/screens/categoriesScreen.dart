// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:news_application/models/categorymodel.dart';
import 'package:news_application/services/api_services.dart';
import 'package:news_application/widgets/category.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

String categoryname = "general";
Future<CategoryModel> fetchdata() async {
  final response = await ApiServices.fetch_api_category(categoryname);
  return response;
}

class _CategoriesState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
     Scaffold(
      body: Category()));
  }
}
