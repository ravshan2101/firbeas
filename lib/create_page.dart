import 'package:firbeas/auth_servic.dart';
import 'package:firbeas/post_method.dart';
import 'package:firbeas/rtdb_servic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var isLoading = false;
  var titlecontroller = TextEditingController();
  var contentcontroller = TextEditingController();

  _createPost() {
    String title = titlecontroller.text.toString();
    String body = contentcontroller.text.toString();
    if (title.isEmpty || body.isEmpty) return;
    _apicreatePost(title, body);
  }

  _apicreatePost(String title, String body) {
    setState(() {
      isLoading = true;
    });
    var post =
        Post(title: title, body: body, userId: Authservic.currentUserId());
    RTDBSservice.addPost(post).then((value) => {_resAddPost()});
  }

  _resAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a post'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: titlecontroller,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: contentcontroller,
                decoration: const InputDecoration(hintText: 'Body'),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  _createPost();
                },
                color: Colors.blue,
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink()
        ]),
      ),
    );
  }
}
