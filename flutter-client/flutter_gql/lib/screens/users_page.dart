import 'package:flutter/material.dart';
import 'package:flutter_gql/screens/details_page.dart';
import 'package:flutter_gql/screens/home_screen.dart';
import 'package:flutter_gql/screens/update_user_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List users = [];
  String _query = """
query {
  users{
    name
    id
    profession
    age
    posts{
       id
       comment
       userId
    }
    hobbies{
      id
      title
      description
      userId
    }
  }

} 

""";

  List hobbiesIDsToDelete = [];
  List postsIdsToDelete = [];

  bool _isRemoveHobby = false;
  bool _isRemovePost = false;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(_query)),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return CircularProgressIndicator();
          }
          users = result.data!["users"];

          return (users.isNotEmpty)
              ? ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Stack(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(bottom: 23, left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    color: Colors.grey.shade300,
                                    blurRadius: 30)
                              ]),
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () async {
                              print(":::User: ${user.toString()}");
                              final route = MaterialPageRoute(
                                builder: (context) {
                                  return DetailsPage(user: user);
                                },
                              );
                              await Navigator.push(context, route);
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${user["name"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.greenAccent,
                                              ),
                                            ),
                                            onTap: () async {
                                              final route = MaterialPageRoute(
                                                builder: (context) {
                                                  return UpdateUser(
                                                      id: user["id"],
                                                      name: user["name"],
                                                      age: user["age"],
                                                      profession:
                                                          user["profession"]);
                                                },
                                              );
                                              await Navigator.push(
                                                  context, route);
                                            },
                                          ),
                                          Mutation(
                                            options: MutationOptions(
                                              document: gql(removeUser()),
                                              onCompleted: (data) {},
                                            ),
                                            builder: (runMutation, result) {
                                              return Padding(
                                                padding: EdgeInsets.all(8),
                                                child: InkWell(
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    hobbiesIDsToDelete.clear();
                                                    postsIdsToDelete.clear();

                                                    for (var i = 0;
                                                        i <
                                                            user["hobbies"]
                                                                .length;
                                                        i++) {
                                                      hobbiesIDsToDelete.add(
                                                          user["hobbies"][i]
                                                              ["id"]);
                                                    }

                                                    for (var i = 0;
                                                        i <
                                                            user["posts"]
                                                                .length;
                                                        i++) {
                                                      postsIdsToDelete.add(
                                                          user["posts"][i]
                                                              ["id"]);
                                                    }
                                                    // print(
                                                    //     "+++${user["name"]} Hobbies to delete: ${hobbiesIDsToDelete.toString()} ");
                                                    // print(
                                                    //     "+++${user["name"]} Posts to delete: ${postsIdsToDelete.toString()}");
                                                    setState(() {
                                                      _isRemoveHobby = true;
                                                      _isRemovePost = true;
                                                    });
                                                    runMutation(
                                                        {"id": user["id"]});
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                      builder: (context) {
                                                        return HomeScreen();
                                                      },
                                                    ), (route) => false);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          _isRemoveHobby
                                              ? Mutation(
                                                  options: MutationOptions(
                                                    document:
                                                        gql(removeHobbies()),
                                                    onCompleted: (data) {},
                                                  ),
                                                  builder:
                                                      (runMutation, result) {
                                                    if (hobbiesIDsToDelete
                                                        .isNotEmpty) {
                                                      print(
                                                          "Calling deleteHobbies...");
                                                      runMutation({
                                                        'ids':
                                                            hobbiesIDsToDelete
                                                      });
                                                    }
                                                    return Container();
                                                  },
                                                )
                                              : Container(),
                                          _isRemovePost
                                              ? Mutation(
                                                  options: MutationOptions(
                                                    document:
                                                        gql(removePosts()),
                                                    onCompleted: (data) {},
                                                  ),
                                                  builder:
                                                      (runMutation, result) {
                                                    if (postsIdsToDelete
                                                        .isNotEmpty) {
                                                      runMutation({
                                                        "ids": postsIdsToDelete
                                                      });
                                                    }
                                                    return Container();
                                                  },
                                                )
                                              : Container()
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Text(
                                        "Occupation: ${user["profession"] ?? 'N/A'}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Text("Age: ${user["age"] ?? 'N/A'}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                )
              : Container(
                  child: Center(
                  child: Text("No items found"),
                ));
        });
  }

  String removeUser() {
    return """
                                                  mutation RemoveUser(\$id: String!) {
                                                    RemoveUser(id: \$id){
                                                       name
                                                    }   
                                                  }
                                                  """;
  }

  String removePosts() {
    return """ 
    mutation RemovePosts(\$ids: [String]) {
      RemovePosts(ids: \$ids){
         
      }   
    }
    """;
  }

  String removeHobbies() {
    return """
    mutation RemoveHobbies(\$ids: [String]) {
      RemoveHobbies(ids: \$ids){
       
      }   
    }
     """;
  }
}
