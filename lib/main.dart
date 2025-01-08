import 'package:flutter/material.dart';
import 'package:hive_blog_api/screens/post_screen.dart';

void main(){
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget{
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    title: 'Hive Blog',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: PostScreen(),
   );

  }

}