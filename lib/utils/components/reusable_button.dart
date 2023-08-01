import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  const ReusableButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15.r)
        ),
        child: Center(
          child: Text(
              text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp
            ),
          ),
        ),
      ),
    );
  }
}
