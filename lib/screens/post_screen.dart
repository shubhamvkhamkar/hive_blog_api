import 'package:flutter/material.dart';
import 'package:hive_blog_api/model/post_model.dart';
import 'package:hive_blog_api/service/post_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostService _postService = PostService();
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
  
    super.initState();
    loadPost();
  }

  Future<void> loadPost() async {
    try {
      final data = await _postService.fetchPosts();
      setState(() {
        posts = data.map((json) => Post.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Fetching Posts $e')));
      setState(() {
        isLoading = false;
      });
    }
  }

  String relativeTime(String date) {
    final dateTime = DateTime.parse(date);
    return timeago.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Post'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadPost,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(post: post, relativeTime: relativeTime);
                },
              )),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final String Function(String) relativeTime;
  const PostCard({super.key, required this.post, required this.relativeTime});

  String removeHtmlTags(String htmlString) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(exp, '');
  }

  

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                post.author ?? 'Unknown Author',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ' in ${post.community ?? 'Unknown community'} . ${relativeTime(post.created ?? ' ')}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          ListTile(
            leading: post.thumbnail != null
                ? Image.network(
                    post.thumbnail!,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image, size: 100, color: Colors.grey),
            title: Text(
              post.title ?? 'No Title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  removeHtmlTags(post.body ?? '')
                      .replaceAll(RegExp(r'\n'), ' ')
                      .substring(
                          0,
                          (post.body ?? '').length > 1000
                              ? 1000
                              : (post.body ?? '').length),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text('${post.votes}', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 15),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text('${post.comments}', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
