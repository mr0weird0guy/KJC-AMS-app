import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ftest/Data/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ParticipantsTile extends StatefulWidget {
  String participantID, takenTime, eventID;
  bool isPresent, isOpenForall, deleteBtn;
  ParticipantsTile({
    super.key,
    required this.participantID,
    required this.takenTime,
    required this.isPresent,
    required this.isOpenForall,
    required this.eventID,
    required this.deleteBtn,
  });

  @override
  _ParticipantsTileState createState() => _ParticipantsTileState();
}

class _ParticipantsTileState extends State<ParticipantsTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
        tileColor: const Color.fromARGB(255, 233, 233, 233),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        leading: !widget.isOpenForall
            ? widget.isPresent
                ? Icon(
                    size: 35.h,
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(size: 35.h, Icons.cancel, color: Colors.red)
            : Icon(
                size: 35.h,
                Icons.check_circle,
                color: Colors.green,
              ),
        title: Text(
          widget.participantID,
          style: GoogleFonts.inter(
              fontSize: 25.sp, fontWeight: FontWeight.w500, color: textColor),
        ),
        trailing: Visibility(
          visible: widget.deleteBtn,
          child: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            iconSize: 30.sp,
            color: dimGrey,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete Entry"),
                    content:
                        Text("Do you want to Delete ${widget.participantID} ?"),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('events')
                              .doc(widget.eventID)
                              .collection('Participants')
                              .doc(widget.participantID)
                              .delete()
                              .then((_) => debugPrint('Deleted'))
                              .catchError((error) =>
                                  debugPrint('Delete failed: $error'));
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
  