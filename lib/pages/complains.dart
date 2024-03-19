import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Complains extends StatefulWidget {
  const Complains({Key? key}) : super(key: key);

  @override
  _ComplainsState createState() => _ComplainsState();
}

class _ComplainsState extends State<Complains> {
  String? jobID;
  String? email;
  String? password;
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              deleteuser(email, password);
            },
            icon: Icon(Icons.abc)),
        automaticallyImplyLeading: false,
        title: const Text('User complaints'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No complaints found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var complain = snapshot.data!.docs[index];
              var userName = complain['complaining about'];
              var userFeedback = complain['number of people complained'];
              var imgurl = complain['userImage'];
              var rating = complain['rating'];
              var profession = complain['profession'];
              var uid = complain['userId'];
              jobID = complain['jobId'];
              print(uid);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete complete User data'),
                            content: Text(
                                'Are you sure you want to delete $userName?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  getWorkerData(uid);
                                  setState(() {
                                    userId = uid;
                                    print(uid);
                                  });

                                  Navigator.pop(context);
                                  showDeleteUserDataDialog();
                                },
                                child: Text('Delete User'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          profession,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "Number of Complaints: ${userFeedback.toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(imgurl),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return _buildStar(index, rating.toDouble());
                      }),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> showDeleteUserDataDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete user data completely'),
          content: const Text(
              'Are you sure you want to delete all data associated with this user?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteUser(email, password);
                deleteUserData(userId!);

                Navigator.pop(context);
              },
              child: const Text('Delete Data',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStar(int index, double rating) {
    IconData iconData = Icons.star_border;
    Color color = Colors.grey;

    if (index < rating) {
      iconData = Icons.star;
      color = Colors.amber;
    }

    return Icon(
      iconData,
      color: color,
    );
  }

  void deleteuser(String? email, String? password) async {
    try {
      if (email != null && password != null) {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        // Sign in the user with their email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Get the currently signed-in user
        User? user = _auth.currentUser;

        if (user != null) {
          // Re-authenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: email.trim(),
            password: password.trim(),
          );
          await user.reauthenticateWithCredential(credential);

          // Delete the user
          await user.delete();
          print('User deleted successfully.');
        } else {
          print('No user signed in.');
        }
      } else {
        print('Email or password is null.');
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  void getWorkerData(String uid) async {
    final DocumentSnapshot workerDoc = await FirebaseFirestore.instance
        .collection('acceptedworkers')
        .doc(uid)
        .get();
    if (workerDoc == null) {
      return;
    } else {
      setState(() {
        email = workerDoc.get('email');
        password = workerDoc.get('password');
        print(email);
        print(password);
        print("userid${userId!}");
      });
    }
  }

  void deleteUser(String? email, String? password) async {
    try {
      if (email != null && password != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password.trim(),
        );
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.reauthenticateWithCredential(credential);
          await user.delete();
          print('User deleted successfully.');
        } else {
          print('No user signed in.');
        }
      } else {
        print('Email or password is null.');
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  void deleteUserData(String userId) async {
    await FirebaseFirestore.instance
        .collection('acceptedworkers')
        .where('id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobID)
        .collection('appliedusers')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        documentSnapshot.reference.delete();
      }
    });

    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        documentSnapshot.reference.delete();
      }
    });
    Fluttertoast.showToast(msg: "User deleted successfully");
  }
}
