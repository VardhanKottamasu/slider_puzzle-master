import '../flutter.dart';

class MaterialInterior extends ImplicitlyAnimatedWidget {
  const MaterialInterior({
    Key? key,
    required this.child,
    required this.shape,
    required this.color,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(key: key, curve: curve, duration: duration);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The border of the widget.
  ///
  /// This border will be painted, and in addition the outer path of the border
  /// determines the physical shape.
  final ShapeBorder shape;

  /// The target background color.
  final Color color;

  @override
  _MaterialInteriorState createState() => _MaterialInteriorState();
}

class _MaterialInteriorState extends AnimatedWidgetBaseState<MaterialInterior> {
  ShapeBorderTween? _border;
  ColorTween? _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _border = visitor(_border, widget.shape,
            (value) => ShapeBorderTween(begin: value as ShapeBorder?))
        as ShapeBorderTween?;
    _color = visitor(
            _color, widget.color, (value) => ColorTween(begin: value as Color?))
        as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final shape = _border!.evaluate(animation)!;
    return PhysicalShape(
      clipper: ShapeBorderClipper(
        shape: shape,
        textDirection: Directionality.of(context),
      ),
      color: _color!.evaluate(animation)!,
      child: _ShapeBorderPaint(
        shape: shape,
        child: widget.child,
      ),
    );
  }
}

class _ShapeBorderPaint extends StatelessWidget {
  const _ShapeBorderPaint({
    required this.child,
    required this.shape,
  });

  final Widget child;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) => CustomPaint(
        foregroundPainter:
            _ShapeBorderPainter(shape, Directionality.of(context)),
        child: child,
      );
}

class _ShapeBorderPainter extends CustomPainter {
  _ShapeBorderPainter(this.border, this.textDirection);

  final ShapeBorder border;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    border.paint(canvas, Offset.zero & size, textDirection: textDirection);
  }

  @override
  bool shouldRepaint(_ShapeBorderPainter oldDelegate) =>
      oldDelegate.border != border;
}
