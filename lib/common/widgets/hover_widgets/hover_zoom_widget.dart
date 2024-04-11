// import 'package:flutter/material.dart';
//
// class HoverImage extends StatefulWidget {
//   final String image;
//
//   const HoverImage({required this.image});
//
//   @override
//   _HoverImageState createState() => _HoverImageState();
// }
//
// class _HoverImageState extends State<HoverImage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation _animation;
//   late Animation padding;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 275),
//       vsync: this,
//     );
//     _animation = Tween(begin: 1.0, end: 1.2)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
//     padding = Tween(begin: 0.0, end: -25.0)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.ease,reverseCurve: Curves.easeIn));
//     _controller.addListener(() {
//       setState(() {});
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (value) {
//         setState(() {
//           _controller.forward();
//         });
//       },
//       onExit: (value) {
//         setState(() {
//           _controller.reverse();
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.0),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0.0, 20.0),
//               spreadRadius: -10.0,
//               blurRadius: 20.0,
//             )
//           ],
//         ),
//         child: Container(
//           height: 200,
//        /*   height: 220.0,
//           width: 170.0,*/
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           clipBehavior: Clip.hardEdge,
//           transform: Matrix4(_animation.value, 0, 0, 0, 0, _animation.value, 0,
//               0, 0, 0, 1, 0, padding.value, padding.value, 0, 1),
//           child: Image.asset(
//             widget.image,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class HoverZoom extends StatefulWidget {
  final Widget child;

  const HoverZoom({required this.child});

  @override
  _HoverZoomState createState() => _HoverZoomState();
}

class _HoverZoomState extends State<HoverZoom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 275),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }


}

// Usage example

