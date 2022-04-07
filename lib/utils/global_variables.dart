import 'package:flutter/material.dart';
import 'package:instaclone/screens/add_post_screen.dart';
import 'package:instaclone/screens/feed_screen.dart';
import 'package:instaclone/screens/search_screen.dart';

const webScreenSize = 600;
List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notif'),
  Text('profile'),
];
