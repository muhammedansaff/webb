import 'package:admin/screens/dashboard/components/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class feedBacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Header(value: 'FeedBacks'),
        ),
        backgroundColor: Color(0xFF212332),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('feedbacks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No feedbacks found.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var feedback = snapshot.data!.docs[index];

                var userFeedback = feedback['feedback'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        userFeedback,
                      ),

                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      // Add trailing if you want to show additional information
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
