import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:trashtrack_user/data/repositories/post_repository.dart';
import 'package:trashtrack_user/models/post/post.dart';

part 'get_posts_event.dart';
part 'get_posts_state.dart';

typedef APBT = Bloc<GetPostsEvent, GetPostsState>;

class GetPostsBloc extends APBT {
  final PostRepository postRepository;
  int fetchedPostsCount = 0;
  bool hasMorePostsAvailable = true; // Add a flag to track available posts

  GetPostsBloc(this.postRepository) : super(GetPostsInitialState()) {
    on<GetPostsEvent>((event, emit) async {
      // If no more posts are available and it's a load more request, return
      if (!hasMorePostsAvailable && event.lastPostId != null) {
        return;
      }

      emit(GetPostsProcessingState());

      final result = await postRepository.getPosts(
          limit: event.limit, lastPostId: event.lastPostId);

      result.fold((String error) {
        emit(GetPostsErrorState(error));
      }, (List<Post> posts) {
        // Update fetchedPostsCount
        fetchedPostsCount = posts.length;

        // Update hasMorePostsAvailable flag
        hasMorePostsAvailable = posts.length == 10; // Assuming 10 is your limit

        emit(GetPostsSuccessfulState(posts,
            hasMorePosts: hasMorePostsAvailable));
      });
    });
  }

  // Remove or modify hasMorePosts method if not used
  bool hasMorePosts() {
    return hasMorePostsAvailable;
  }
}
