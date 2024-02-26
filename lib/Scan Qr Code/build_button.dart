import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  final VoidCallback? onPressed;
 final  String imageAsset;

  const BuildButton({Key? key, this.onPressed,required this.imageAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height*1;
    final width=MediaQuery.sizeOf(context).width*1;
    return GestureDetector(
      onTap: onPressed,
      child: Container(

        decoration: const BoxDecoration(

          color: Colors.white,
          border: Border.fromBorderSide(

            BorderSide(
              style: BorderStyle.solid,

              color: Colors.white,
              width: 2,
            ),
          ),
        ),
        child: Image.asset(imageAsset, fit: BoxFit.cover,height: height * 0.082,
        ),
      ),
    );
  }
}
