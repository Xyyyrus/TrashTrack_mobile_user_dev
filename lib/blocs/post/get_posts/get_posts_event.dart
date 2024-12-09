part of 'get_posts_bloc.dart';

class GetPostsEvent {
  final String? lastPostId; // For pagination (optional)
  final int limit; // Number of posts to fetch (non-nullable)
  final bool hasMorePosts; // Add the hasMorePosts property

  GetPostsEvent({
    this.lastPostId,
    this.limit = 10, // Default limit to 10 if not provided
    this.hasMorePosts = false,
  });
}
