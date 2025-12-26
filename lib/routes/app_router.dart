import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_company_application/routes/app_routes.dart';
import 'package:generic_company_application/screens/concerns/add_concern_screen.dart';
import 'package:generic_company_application/screens/concerns/concerns_screen.dart';
import 'package:generic_company_application/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/post_screens/posts_view_screen.dart';
import '../screens/post_screens/add_post_screen.dart';
import '../screens/post_screens/current_user_posts_view_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAtHome = state.matchedLocation == AppRoutes.home;

    // User NOT logged in
    if (user == null) {
      return isAtHome ? null : AppRoutes.home;
    }

    // User logged in
    if (isAtHome) {
      return AppRoutes.viewPosts;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => ProfileScreen(),
    ),

    GoRoute(
      path: AppRoutes.viewPosts,
      builder: (context, state) => const PostsViewScreen(),
    ),
    GoRoute(
      path: AppRoutes.currentUserPosts,
      builder: (context, state) => const CurrentUserPostsViewScreen(),
    ),
    GoRoute(
      path: AppRoutes.viewConcerns,
      builder: (context, state) => const ConcernsScreen(),
    ),
    GoRoute(
      path: AppRoutes.addPost,
      builder: (context, state) => const AddPostScreen(),
    ),
    GoRoute(
      path: AppRoutes.addConcern,
      builder: (context, state) => const AddConcernScreen(),
    ),
  ],
);
