import 'package:admin/Services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserView extends StatefulWidget {
  final String userName;
  final String email;
  final String uid;
  final String userImage;
  final String phoneNumber;
  final String prof;
  final String img;
  final bool check;
  final String pass;
  final Timestamp createdAt;

  final bool isWorker;
  const UserView(
      {super.key,
      required this.isWorker,
      required this.createdAt,
      required this.pass,
      required this.check,
      required this.img,
      required this.prof,
      required this.email,
      required this.uid,
      required this.userName,
      required this.userImage,
      required this.phoneNumber});

  @override
  State<UserView> createState() => _UserViewState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _UserViewState extends State<UserView> {
  _deleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete user'),
          content: Text(
            'do you want to delete the user ${widget.userName}?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Delete the job document

                  await FirebaseFirestore.instance
                      .collection('workers')
                      .doc(widget.email.toString())
                      .delete();

                  // Delete the 'applied' collection

                  await Fluttertoast.showToast(
                    msg: '${widget.userName} deleted',
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.grey,
                    fontSize: 18,
                    gravity: ToastGravity.CENTER,
                  );

                  // ignore: use_build_context_synchronously
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                } catch (error) {
                  // ignore: use_build_context_synchronously
                  GlobalMethod.showErrorDialog(
                    error: 'This task cannot be deleted',
                    ctx: context,
                  );
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showUserDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.userName),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Email: ${widget.email}'),
                Text('Phone Number: ${widget.phoneNumber}'),
                Text('Profession: ${widget.prof}'),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Image'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.5, // Adjust the width as needed
                                    height: MediaQuery.of(context).size.height *
                                        0.5, // Adjust the height as needed
                                    child: Image.network(widget.img.toString()),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          const SizedBox(width: 5),
                          Text("${widget.userName}'s ID"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

// Replace this with your implementation to securely store and retrieve the password

  void _updateStatus(bool newStatus) async {
    try {
      // Update the status in the workers collection
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.uid) // Assuming uid is the unique identifier for the user
          .update({'status': newStatus});

      if (newStatus) {
        await _auth.createUserWithEmailAndPassword(
            email: widget.email.trim().toLowerCase(),
            password: widget.pass.trim());
        final User? user = _auth.currentUser;
        final uid = user!.uid;

        // Create a new document in the acceptedworkers collection
        await FirebaseFirestore.instance
            .collection('acceptedworkers')
            .doc(uid)
            .set({
          'id': uid,
          'email': widget.email,
          'name': widget.userName,
          'createdAt': widget.createdAt,
          'imageUrl': widget.userImage,
          'isWorker': widget.isWorker,
          'myId': widget.img,
          'phoneNumber': widget.phoneNumber,
          'profession': widget.prof,
          'status': true,
          'password': widget.pass
        });

        FirebaseFirestore.instance.collection('workeranduser').doc(uid).set(
          {
            'phoneNumber': widget.phoneNumber,
            'id': uid,
            'name': widget.userName,
            'email': widget.email,
            'isWorker': true,
            'userImage': widget.userImage
          },
        );

        Fluttertoast.showToast(
          msg: 'Status updated successfully and user signed in',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (error) {
      GlobalMethod.showErrorDialog(
        error: 'Failed to update status: $error',
        ctx: context,
      );
    }
  }

  void _deleteUser() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Delete user from Firebase Authentication

      // Delete the user document from Firestore
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.uid)
          .delete();

      Fluttertoast.showToast(
        msg: 'User deleted successfully',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
        fontSize: 18,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      GlobalMethod.showErrorDialog(
        error: 'Failed to delete user: $error',
        ctx: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: Color(0xFF212332), // Set card color to match scaffold color
        shadowColor: Color(0xFFECE5B6),
        elevation: 15,
        child: ListTile(
          onTap: () {
            _showUserDetailsDialog();
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: const Color(0xFFECE5B6),
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFECE5B6),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4), // Decreased vertical space here
                    Text(
                      widget.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white, // Change email color
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              widget.check
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                _updateStatus(true);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteUser();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
          subtitle: Text(
            widget.prof,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.white, // Change icon color
          ),
        ),
      ),
    );
  }
}
