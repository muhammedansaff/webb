import 'package:admin/pages/userView.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Worker requests'),
      ),
      body: const UserRequestsView(),
    );
  }
}

class UserRequestsView extends StatelessWidget {
  const UserRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('workers')
          .where('status', isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // ignore: avoid_print
          print('Error fetching data: ${snapshot.error}');
          return const Center(child: Text('Error fetching data'));
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No request found'));
        }

        // ignore: avoid_print
        print('Data count: ${snapshot.data!.docs.length}');
        // ignore: avoid_print

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final userDoc = snapshot.data!.docs[index];
            final phone = userDoc['phoneNumber'];
            final emaill = userDoc['email'];
            final createdAt = userDoc['createAt'];
            final uid = userDoc['id'];
            final name = userDoc['name'];
            final profession = userDoc['profession'];
            final userImage = userDoc['userImage'];
            final idimg = userDoc['myId'];
            final pass = userDoc['password'];
            final isworker = userDoc['isWorker'];
            return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 4), // Add vertical spacing here
                child: UserView(
                    isWorker: isworker,
                    createdAt: createdAt,
                    pass: pass,
                    check: true,
                    img: idimg,
                    phoneNumber: phone,
                    email: emaill,
                    uid: uid,
                    userName: name,
                    prof: profession,
                    userImage: userImage));
          },
        );
      },
    ); //code for filtered list builder
  }
}
