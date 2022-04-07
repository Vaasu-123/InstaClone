import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_providers.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  final TextEditingController _commentController = TextEditingController();
  CommentScreen({
    Key? key,
    this.snap = const {},
  }) : super(key: key);
  //final snap = {};
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget._commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<Userprovider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postId"])
            .collection("comments")
            .orderBy("datePublished", descending: true,)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length ,
            itemBuilder: (context, index){
              return CommentCard(
                snap: (snapshot.data! as dynamic).docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 8.0,
                  ),
                  child: TextField(
                    controller: widget._commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FireStoreMethods().postComments(
                    widget.snap['postId'],
                    widget._commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );
                  widget._commentController.text = "";
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
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
