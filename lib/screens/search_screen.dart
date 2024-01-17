import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_project/screens/profile_screen.dart';
import 'package:instagram_clone_project/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      gapPadding: 8
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor : mobileBackgroundColor,
        title: Container(
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8
          ),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search
              ),
              hintText: 'Search',
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder,
              filled: true,
            
            ),
            onFieldSubmitted: (String){
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        
      ),
      body: isShowUsers? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users')
        .where('username', isGreaterThanOrEqualTo: _searchController.text)
        .get(),
        builder: ((context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(!snapshot.hasData){
            return Container(
              child: Text(
                'No user Found'
              ),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid'])
                )),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      (snapshot.data! as dynamic).docs[index]['photoUrl'],
                    ),
                  ),
                  title: Text(
                    (snapshot.data! as dynamic).docs[index]['username'],
                  ),
                ),
              );
            }
          );
        }),
      ):
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(), 
        builder:(context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: EdgeInsets.only(
              top: 8
            ),
            child: MasonryGridView.count(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index){
                return Image.network(
                  (snapshot.data! as dynamic).docs[index]['postUrl']
                );
              }
              
          
            ),
          );
        }
      )
    );
  }
} 