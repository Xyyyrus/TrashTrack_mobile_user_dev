import 'package:dartz/dartz.dart';
import 'package:trashtrack_user/data/sources/post/add_post_source.dart';
import 'package:trashtrack_user/data/sources/post/delete_post_source.dart';
import 'package:trashtrack_user/data/sources/post/edit_post_source.dart';
import 'package:trashtrack_user/data/sources/post/get_posts_source.dart';
import 'package:trashtrack_user/data/sources/post/report_post_source.dart';
import 'package:trashtrack_user/models/post/post.dart';
import 'package:trashtrack_user/models/report/report.dart';

typedef FESST = Future<
    Either<String, String>>; // For single result responses (Success/Error)
typedef FESLT = Future<Either<String, List<Post>>>; // For list of posts

class PostRepository {
  final AddPostSource addPostSource;
  final GetPostsSource getPostsSource;
  final DeletePostSource deletePostSource;
  final EditPostSource editPostSource;
  final ReportPostSource reportPostSource;

  PostRepository({
    required this.addPostSource,
    required this.getPostsSource,
    required this.deletePostSource,
    required this.editPostSource,
    required this.reportPostSource,
  });

  FESST addPost(Post post) async {
    return await addPostSource.addPost(post);
  }

  FESLT getPosts({String? lastPostId, int limit = 10}) async {
    return await getPostsSource.getPosts(lastPostId: lastPostId, limit: limit);
  }

  FESST deletePost(Post post) async {
    return await deletePostSource.deletePost(post);
  }

  FESST editPost(Post post) async {
    return await editPostSource.editPost(post);
  }

  FESST reportPost(Report report) async {
    return await reportPostSource.reportPost(report);
  }
}
