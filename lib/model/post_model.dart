class Post{
 final String? title;
 final String? author;
 final String? community;
 final String? created;
 final int votes;
 final int comments;
 final String? body;
 final String? thumbnail;


  Post({
  this.title, 
  this.author,
  this.community, 
  this.created, 
   required this.votes, 
   required this.comments, 
   this.body, 
   this.thumbnail,
   });

   factory Post.fromJson(Map<String,dynamic> json){
    final thumbnail = json['json_metadata']?['image']?.isNotEmpty == true
      ? json['json_metadata']['image'][0]
      : null;

     return Post(
      
      title: json['title']??'No title',
       author: json['author'] ?? 'unkown Author', 
       community: json['community'] ?? 'unkown Community', 
       created: json['created']?? DateTime.now().toString(), 
       votes: json['stats']['total_votes']?? 0, 
       comments: json['children']?? 0, 
       body: json['body'] ?? '',
       thumbnail: thumbnail,
       
       );
   }

}