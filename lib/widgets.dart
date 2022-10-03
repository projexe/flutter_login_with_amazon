part of 'flutter_login_with_amazon.dart';

const packageName = 'flutter_login_with_amazon';
///
/// This class returns a button widget displaying the 'Login With Amazon'
/// logo and button layout.
/// It requires an [onPressed] callback function to be passed in, which is
/// actioned when the button is pressed. Generally this should be a call to
/// one of the functions provided by this plugin
///
class LwaButton extends StatefulWidget {
  final VoidCallback onPressed;

  const LwaButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  LwaButtonState createState() => LwaButtonState();
}

class LwaButtonState extends State<LwaButton> {
  static const String btnImageUnpressed =
      'assets/images/btnlwa_gold_loginwithamazon.png';
  static const String btnImagePressed =
      'assets/images/btnlwa_gold_loginwithamazon_pressed.png';
  String _btnImage = btnImageUnpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (tap) {
       //   setState(() {
            setState(() {
              _btnImage = btnImagePressed;
            });
       //   });
        },
        onTapUp: (tap) {
          //setState(() {
            setState(() {
              _btnImage = btnImageUnpressed;
            });
          //});
        },
        child: SizedBox(
            width: 200,
            child: IconButton(
              icon: Image(image: AssetImage(_btnImage, package: packageName)),
              iconSize: 50,
              onPressed: widget.onPressed,
            )));
  }
}
