import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_colors.dart';

class SpecialLinks extends StatelessWidget {
  // thats the right way to name classes SpecialLinks okay Bye
// DatabaseReference reference = _firebase.reference().child("")
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  SpecialLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> specialLinksStream = _firebase.collection('Links').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Links"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: specialLinksStream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snap.hasData && snap.data != null) {
            final docList = snap.data!.docs;
            if (docList.isEmpty) {
              return const Text("No Data"); // working
            }
            return ListView.builder(
              itemCount: docList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      _launchInBrowser(docList[index].get('URL'));
                    },
                    title: Text(docList[index].get('URL_Name')),
                  ),
                );
              },
            );
          }
          return const Text("Something went wrong!");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(url)) {
      debugPrint("Could not launch $url");
    } else {
      launch(url);
    }
  }
}

class Add extends StatelessWidget {
  final TextEditingController urlNameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  // final firebase = FirebaseFirestore.instance.collection("Links");
  final firebase = FirebaseFirestore.instance;

  Add({Key? key}) : super(key: key);

  Future<void> create() async {
    final String urlName = urlNameController.text.trim();
    final String url = urlController.text.trim();

    try {
      await firebase.collection("Links").doc(urlNameController.text.trim()).set({
        "URL_Name": urlName,
        "URL": url,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      await firebase.collection("Links").doc(urlController.text.trim()).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "ADD LINKS",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: urlNameController,
              decoration: const InputDecoration(
                labelText: "URL name",
              ),
            ),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: "Enter URL",
              ),
            ),
            const SizedBox(height: 24.0),
            TextButton(
              // flat button is deprecated
              style: TextButton.styleFrom(
                backgroundColor: AppColors.mainColor,
              ),
              child: const Text(
                "Add",
                style: TextStyle(color: AppColors.btnColor),
              ),
              onPressed: () {
                create();
                urlNameController.clear();
                urlController.clear();
              },
            )
          ],
        ),
      ),
    );
  }
}


// getAllLinks() {
//   FirebaseFirestore.instance.collection("Links").snapshots();
// }

// Widget geetBody(BuildContext context) {
//   return StreamBuilder<QuerySnapshot>(
//     stream: getAllLinks(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Text("Error");
//       }
//       if (snapshot.hasData) {
//         print("Links ${snapshot.data.docs.length}");
//       }
//     },
//   );
// }
