import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_company_application/models/post_model.dart';
import 'package:generic_company_application/routes/app_routes.dart';
import 'package:generic_company_application/screens/posts/post_card.dart';
import 'package:generic_company_application/services/local_storage.dart';
import 'package:generic_company_application/services/user_service.dart';
import 'package:generic_company_application/utils/helpers.dart';
import 'package:generic_company_application/screens/widgets/app_drawer.dart';
import 'package:generic_company_application/services/auth_service.dart';
import 'package:generic_company_application/services/post_service.dart';
import 'package:go_router/go_router.dart';

class PostsViewScreen extends StatefulWidget {
  const PostsViewScreen({super.key});

  @override
  State<PostsViewScreen> createState() => _PostsViewScreenState();
}

class _PostsViewScreenState extends State<PostsViewScreen> {
  final List<PostModel> posts = [];
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<PostModel>? _newPostSubscription;
  StreamSubscription<String>? _deletePostSubscription;
  StreamSubscription<PostModel>? _editPostSubscription;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "null";

  bool _isLoading = false;
  bool _hasMore = true;
  int? _lastTimeCreated;

  @override
  void initState() {
    super.initState();
    _loadPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadPosts();
      }
    });
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);

    final newPosts = await postService.fetchPosts(
      limit: 10,
      lastTimeCreated: _lastTimeCreated,
    );

    if (newPosts.isEmpty) {
      _hasMore = false;
    } else {
      _lastTimeCreated = newPosts.last.timeCreated;
      posts.addAll(newPosts);

      if (posts.isNotEmpty && _newPostSubscription == null) {
        _startRealtimeListener(posts.first.timeCreated);
        _startDeleteListener();
        _startEditListener();
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _refreshPosts() async {
    posts.clear();
    _lastTimeCreated = null;
    _hasMore = true;
    await _loadPosts();
  }

  void _startRealtimeListener(int latestTimeCreated) {
    _newPostSubscription = postService
        .listenForNewPosts(latestTimeCreated)
        .listen((newPost) {
          setState(() {
            posts.insert(0, newPost);
          });
        });
  }

  void _startDeleteListener() {
    _deletePostSubscription = postService.listenForDeletedPosts().listen((
      deletedPostId,
    ) {
      setState(() {
        posts.removeWhere((post) => post.id == deletedPostId);
      });
    });
  }

  void _startEditListener() {
    _editPostSubscription = postService.listenForUpdatedPosts().listen((
      updatedPost,
    ) {
      final index = posts.indexWhere((post) => post.id == updatedPost.id);

      if (index != -1) {
        setState(() {
          posts[index] = updatedPost;
        });
      }
    });
  }

  void logoutbutton() async {
    _newPostSubscription?.cancel();
    _deletePostSubscription?.cancel();
    _editPostSubscription?.cancel();

    await AuthService().logout();
    await LocalStorage.clear();
    Helpers.showSuccessSnackbar(context, "Logged Out Successfully");
    context.go(AppRoutes.home);
  }

  void deleteAccount() async {
    _newPostSubscription?.cancel();
    _deletePostSubscription?.cancel();
    _editPostSubscription?.cancel();

    // Delete user data from database first (while still authenticated)
    await UserService.instance.deleteUser(userId);
    // Delete Firebase auth account 
    await AuthService().deleteAccount();
    // Clear local storage
    await LocalStorage.clear();
    
    Helpers.showSuccessSnackbar(context, "Account Deleted Successfully");
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _newPostSubscription?.cancel();
    _deletePostSubscription?.cancel();
    _editPostSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      drawer: AppDrawer(logout: logoutbutton, delete: deleteAccount),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }

            return PostCard(post: posts[index]);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.post_add),
                        title: const Text("Add Post"),
                        onTap: () {
                          context.pop();
                          context.push(AppRoutes.addPost);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.report_problem_outlined),
                        title: const Text("Add Concern"),
                        onTap: () {
                          context.pop();
                          context.push(AppRoutes.addConcern);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // VIEW POSTS
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.push(AppRoutes.currentUserPosts);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.article, size: 24),
                      SizedBox(height: 2),
                      Text("View Posts", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 40),
              // VIEW CONCERNS
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.push(AppRoutes.viewConcerns);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.feedback, size: 24),
                      SizedBox(height: 2),
                      Text("View Concerns", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
