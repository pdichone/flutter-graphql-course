import 'package:flutter/material.dart';
import 'package:flutter_gql/screens/home_screen.dart';
import 'package:flutter_gql/stylings/stylings.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateUser extends StatefulWidget {
  final String id;
  final String name;
  final int age;
  final String profession;

  const UpdateUser(
      {Key? key,
      required this.id,
      required this.name,
      required this.age,
      required this.profession})
      : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _professionController.text = widget.profession;
    _ageController.text = widget.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Update ${widget.name}",
          style: TextStyle(
              color: Colors.grey, fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: Offset(0, 10),
                      blurRadius: 30)
                ]),
            child: Column(
              children: [
                Mutation(
                  options: MutationOptions(
                    document: gql(updateUser()),
                    fetchPolicy: FetchPolicy.noCache,
                    onCompleted: (data) {
                      _isSaving = false;

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ), (route) => false);
                    },
                  ),
                  builder: (runMutation, result) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _nameController,
                            decoration: new InputDecoration(
                                labelText: "Name",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide())),
                            validator: (v) {
                              if (v!.length == 0) {
                                return "Name cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _professionController,
                            decoration: new InputDecoration(
                                labelText: "Profession",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide())),
                            validator: (v) {
                              if (v!.length == 0) {
                                return "Profession cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _ageController,
                            decoration: new InputDecoration(
                                labelText: "Age",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide())),
                            validator: (v) {
                              if (v!.length == 0) {
                                return "Age cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12),
                          _isSaving
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isSaving = true;
                                      });
                                      runMutation({
                                        'id': widget.id,
                                        'name': _nameController.text
                                            .toString()
                                            .trim(),
                                        'profession':
                                            _professionController.text.trim(),
                                        'age': int.parse(_ageController.text)
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 36, vertical: 12),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                  style: buildButtonStyle(),
                                )
                        ],
                      ),
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}

String updateUser() {
  return """
    mutation UpdateUser(\$id: String!, \$name: String!, \$profession: String!, \$age: Int!) {
      UpdateUser(id: \$id, name: \$name, profession: \$profession, age: \$age){
         
         name
      }   
    }
    """;
}
