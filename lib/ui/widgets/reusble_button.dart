import 'package:flutter/material.dart';


class Rounded_Button extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool loading;
 const  Rounded_Button({
    super.key,
    required this.title,
    required this.ontap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 47,
        width: 318,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.green),
        // we can write code (loding? CircularProgressIndicator() : Text()...)
        // its mean if loading is true the show progress indicator else show the given text
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 5, color: Colors.white)
                : Text(title,
                    style: const TextStyle(
                      color:Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ))),
      ),
    );
  }
}
