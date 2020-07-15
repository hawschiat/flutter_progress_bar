library flutter_progress_bar;
import 'package:flutter/material.dart';

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;
  final Color valueColor;
  final Color backgroundColor;

  AnimatedProgressIndicator({
    Key key,
    this.value = 0.0,
    this.valueColor,
    this.backgroundColor
  }): super(key: key);

  @override
  _AnimatedProgressIndicatorState createState() => _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  double _currentBegin = 0;
  double _currentEnd = 0;

  @override
  void initState() {
    super.initState();
    _currentBegin = widget.value;
    _currentEnd = widget.value;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this
    );
    this._animation = Tween(begin: _currentBegin, end: _currentEnd).animate(_controller);
    _triggerAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    _triggerAnimation();
    super.didUpdateWidget(oldWidget);
  }

  void _triggerAnimation() {
    setState(() {
      _currentBegin = _animation.value;
      _currentEnd = widget.value;
      _animation = Tween<double>(begin: _currentBegin, end: _currentEnd)
          .animate(_controller);
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 20,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 10,
                    child: _AnimatedProgressBar(
                      animation: _animation,
                      valueColor: widget.valueColor,
                      backgroundColor: widget.backgroundColor,
                    ),
                  ),
                ),
              ),
              _AnimatedProgressClip(
                animation: _animation,
                maxWidth: constraints.maxWidth,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedProgressBar extends AnimatedWidget {
  final Color valueColor;
  final Color backgroundColor;

  _AnimatedProgressBar({
    Key key,
    Animation<double> animation,
    this.valueColor,
    this.backgroundColor
  }): super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return LinearProgressIndicator(
      value: animation.value,
      valueColor: this.valueColor != null ? AlwaysStoppedAnimation<Color>(this.valueColor) : null,
      backgroundColor: this.backgroundColor,
    );
  }
}

class _AnimatedProgressClip extends AnimatedWidget {
  final double maxWidth;
  final double size;

  _AnimatedProgressClip({Key key, Animation<double> animation, this.size = 20, this.maxWidth}): super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Positioned(
      left: (animation.value * this.maxWidth) - (this.size / 2),
      child: Container(
        width: this.size,
        height: this.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800].withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
