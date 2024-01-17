import 'package:flutter/material.dart';
import 'package:instagram_clone_project/resources/firestore_methods.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String postId;
  const CommentCard({super.key,required this.snap,required this.postId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showDialog(context: context, builder: (context){
        return Dialog(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16,horizontal: 2),
            shrinkWrap: true,
            children : [
              InkWell(
                onTap: ()async{
                  FirestoreMethods().deleteComment(widget.postId, widget.snap['commentId']);
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    'Delete',
                  )
                ),
              )
            ]
          ),
        );
      }),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18,horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.snap['profileImg'],
              ),
              radius: 20,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.snap['name'],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                          ),
                          child : Text(
                            DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate()
                            ),
                            style: TextStyle(
                              color: secondaryColor,
                            ),
                          )
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10),
                      child: Text(
                        widget.snap['text'],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(left:12),
              child : IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.favorite_border,
                  color: secondaryColor,
                ),
              ),
             
            ),
          ],
        ),
      ),
    );
  }
}