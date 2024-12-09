import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashtrack_user/blocs/analysis/get_analysis/get_analysis_bloc.dart';
import 'package:trashtrack_user/blocs/announcement/get_announcements/get_announcements_bloc.dart';
import 'package:trashtrack_user/blocs/auth/check/check_email_bloc.dart';
import 'package:trashtrack_user/blocs/auth/forgot/forgot_bloc.dart';
import 'package:trashtrack_user/blocs/auth/login/login_bloc.dart';
import 'package:trashtrack_user/blocs/auth/logout/logout_bloc.dart';
import 'package:trashtrack_user/blocs/auth/register/register_bloc.dart';
import 'package:trashtrack_user/blocs/comment/add_comment/add_comment_bloc.dart';
import 'package:trashtrack_user/blocs/comment/delete_comment/delete_comment_bloc.dart';
import 'package:trashtrack_user/blocs/comment/edit_comment/edit_comment_bloc.dart';
import 'package:trashtrack_user/blocs/comment/get_comments/get_comments_bloc.dart';
import 'package:trashtrack_user/blocs/post/add_post/add_post_bloc.dart';
import 'package:trashtrack_user/blocs/post/delete_post/delete_post_bloc.dart';
import 'package:trashtrack_user/blocs/post/edit_post/edit_post_bloc.dart';
import 'package:trashtrack_user/blocs/post/get_posts/get_posts_bloc.dart';
import 'package:trashtrack_user/blocs/post/report_post/report_post_bloc.dart';
import 'package:trashtrack_user/blocs/profile/get_profile/get_profile_bloc.dart';
import 'package:trashtrack_user/blocs/profile/update_profile/update_profile_bloc.dart';
import 'package:trashtrack_user/blocs/route/get_routes/get_routes_bloc.dart';
import 'package:trashtrack_user/blocs/schedule/get_schedules/get_schedules_bloc.dart';
import 'package:trashtrack_user/data/repositories/analysis_repository.dart';
import 'package:trashtrack_user/data/repositories/announcement_repository.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';
import 'package:trashtrack_user/data/repositories/comment_repository.dart';
import 'package:trashtrack_user/data/repositories/fleet_repository.dart';
import 'package:trashtrack_user/data/repositories/post_repository.dart';
import 'package:trashtrack_user/data/repositories/profile_repository.dart';
import 'package:trashtrack_user/data/repositories/route_repository.dart';
import 'package:trashtrack_user/data/repositories/schedule_repository.dart';
import 'package:trashtrack_user/data/sources/analysis/get_analysis_source.dart';
import 'package:trashtrack_user/data/sources/announcement/get_announcements_source.dart';
import 'package:trashtrack_user/data/sources/auth/check_email_source.dart';
import 'package:trashtrack_user/data/sources/auth/forgot_source.dart';
import 'package:trashtrack_user/data/sources/auth/login_source.dart';
import 'package:trashtrack_user/data/sources/auth/logout_source.dart';
import 'package:trashtrack_user/data/sources/auth/register_source.dart';
import 'package:trashtrack_user/data/sources/comment/add_comment_source.dart';
import 'package:trashtrack_user/data/sources/comment/delete_comment_source.dart';
import 'package:trashtrack_user/data/sources/comment/edit_comment_source.dart';
import 'package:trashtrack_user/data/sources/comment/get_comments_source.dart';
import 'package:trashtrack_user/data/sources/fleet/get_distance_source.dart';
import 'package:trashtrack_user/data/sources/fleet/get_fleet_source.dart';
import 'package:trashtrack_user/data/sources/fleet/get_status_source.dart';
import 'package:trashtrack_user/data/sources/post/add_post_source.dart';
import 'package:trashtrack_user/data/sources/post/delete_post_source.dart';
import 'package:trashtrack_user/data/sources/post/edit_post_source.dart';
import 'package:trashtrack_user/data/sources/post/get_posts_source.dart';
import 'package:trashtrack_user/data/sources/post/report_post_source.dart';
import 'package:trashtrack_user/data/sources/profile/get_profile_source.dart';
import 'package:trashtrack_user/data/sources/profile/update_profile_source.dart';
import 'package:trashtrack_user/data/sources/route/get_route_source.dart';
import 'package:trashtrack_user/data/sources/route/get_routes_source.dart';
import 'package:trashtrack_user/data/sources/schedule/get_schedules_source.dart';
import 'package:trashtrack_user/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:trashtrack_user/pages/register_page.dart';

dynamic _repositoryProviders() {
  return [
    RepositoryProvider(
      create: (BuildContext context) => AuthRepository(
        loginSource: LoginSource(),
        loginSourceGoogle: LoginSourceGoogle(),
        logoutSource: LogoutSource(),
        forgotSource: ForgotSource(),
        registerSource: RegisterSource(),
        checkEmailSource: CheckEmailSource(),
      ),
    ),
    BlocProvider(
      create: (BuildContext context) => RegisterBloc(
        context.read<AuthRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => LoginBloc(
        AuthRepository(
          loginSource: LoginSource(),
          loginSourceGoogle: LoginSourceGoogle(),
          logoutSource: LogoutSource(),
          registerSource: RegisterSource(),
          forgotSource: ForgotSource(),
          checkEmailSource: CheckEmailSource(),
        ),
      ),
      child: const LoginPage(),
    ),
    RepositoryProvider(
      create: (BuildContext context) => AnnouncementRepository(
        getAnnouncementsSource: GetAnnouncementsSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => ProfileRepository(
        getProfileSource: GetProfileSource(),
        updateProfileSource: UpdateProfileSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => ScheduleRepository(
        getSchedulesSource: GetSchedulesSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => RouteRepository(
        getRouteSource: GetRouteSource(),
        getRoutesSource: GetRoutesSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => FleetRepository(
        getFleetSource: GetFleetSource(),
        getStatusSource: GetStatusSource(),
        getDistanceSource: GetDistanceSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => PostRepository(
        addPostSource: AddPostSource(),
        getPostsSource: GetPostsSource(),
        deletePostSource: DeletePostSource(),
        editPostSource: EditPostSource(),
        reportPostSource: ReportPostSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => CommentRepository(
        addCommentSource: AddCommentSource(),
        getCommentsSource: GetCommentsSource(),
        deleteCommentSource: DeleteCommentSource(),
        editCommentSource: EditCommentSource(),
      ),
    ),
    RepositoryProvider(
      create: (BuildContext context) => AnalysisRepository(
        getAnalysisSource: GetAnalysisSource(),
      ),
    ),
  ];
}

dynamic _blocProviders = [
  BlocProvider(
    create: (BuildContext context) => GetRoutesBloc(
      context.read<RouteRepository>(),
    ),
  ),
  BlocProvider(
      create: (BuildContext context) =>
          CheckEmailBloc(authRepository: context.read<AuthRepository>())
      // Your RegisterPage widget
      ),
  BlocProvider(
    create: (BuildContext context) => LoginBloc(
      context.read<AuthRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => LogoutBloc(
      context.read<AuthRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => ForgotBloc(
      context.read<AuthRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => GetAnnouncementsBloc(
      context.read<AnnouncementRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => GetProfileBloc(
      context.read<ProfileRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => UpdateProfileBloc(
      context.read<ProfileRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => GetSchedulesBloc(
      context.read<ScheduleRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => AddPostBloc(
      context.read<PostRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => GetPostsBloc(
      context.read<PostRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => DeletePostBloc(
      context.read<PostRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => EditPostBloc(
      context.read<PostRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => ReportPostBloc(
      context.read<PostRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => AddCommentBloc(
      context.read<CommentRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => GetCommentsBloc(
      context.read<CommentRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => DeleteCommentBloc(
      context.read<CommentRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => EditCommentBloc(
      context.read<CommentRepository>(),
    ),
  ),
  BlocProvider(
    create: (BuildContext context) => GetAnalysisBloc(
      context.read<AnalysisRepository>(),
    ),
  ),
];

class Providers {
  static dynamic getRepositoryProviders() => _repositoryProviders();
  static get getBlocProviders => _blocProviders;
}
