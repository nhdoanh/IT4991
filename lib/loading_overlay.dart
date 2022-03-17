import 'package:flutter/material.dart';

void loadingOverlay(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: Container(
                // padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 60,
                height: 60,
                child: const CircularProgressIndicator(),
              ),
            ),
          ));
}
