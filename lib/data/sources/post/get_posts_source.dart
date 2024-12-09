import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trashtrack_user/converters/timestamp_converter.dart';
import 'package:trashtrack_user/data/repositories/post_repository.dart';
import 'package:trashtrack_user/models/post/post.dart';
import 'package:trashtrack_user/models/profile/profile.dart';

class GetPostsSource {
  Future<Either<String, List<Post>>> getPosts({
    String? lastPostId,
    int limit = 10,
  }) async {
    try {
      final firebaseFire = FirebaseFirestore.instance;
      final postsCol = firebaseFire.collection('posts');
      final usersCol = firebaseFire.collection('users');
      final commentsCol = firebaseFire.collection('comments');

      Query query =
          postsCol.orderBy('createdAt', descending: true).limit(limit);

      if (lastPostId != null) {
        final lastPostSnapshot = await postsCol.doc(lastPostId).get();
        if (!lastPostSnapshot.exists) {
          return Left("Invalid lastPostId");
        }
        query = query.startAfterDocument(lastPostSnapshot);
      }

      final postsSnapshot = await query.get();
      final List<Post> postsObjects = [];

      for (var postDoc in postsSnapshot.docs) {
        final postMap = postDoc.data() as Map<String, dynamic>?;
        if (postMap == null) continue;

        final createdAt = postMap['createdAt'];
        if (createdAt == null) continue;

        var postObject = Post.fromJson({
          ...postMap,
          'id': postDoc.id,
          'createdAt': const TimestampConverter().toJson(createdAt),
        });

        // Fetch author details
        final userRef = usersCol.doc(postObject.uid);
        final userSnapshot = await userRef.get();
        if (userSnapshot.exists) {
          final userMap = userSnapshot.data() as Map<String, dynamic>;
          final userObj = Profile.fromJson({
            ...userMap,
            'id': userSnapshot.id,
          });
          postObject = postObject.copyWith(
            author: '${userObj.firstname} ${userObj.lastname}',
          );
        }

        // Fetch comments count
        final commentsCond =
            commentsCol.where('postId', isEqualTo: postObject.id);
        final commentsSnapshot = await commentsCond.get();
        final commentsCount = commentsSnapshot.size;

        postObject = postObject.copyWith(commentsCount: commentsCount);
        postsObjects.add(postObject);
      }

      return Right(postsObjects);
    } catch (e) {
      return Left("Error fetching posts: ${e.toString()}");
    }
  }
}
