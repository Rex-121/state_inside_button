library state_inside_button;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateInsideButton<T extends StateInside> extends StatelessWidget {
  StateInsideButton(this._stateStream, [this._height = 53.0]);

  final double _height;

  final Stream<T> _stateStream;

  final StreamController<T> actionStreamController = StreamController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: _stateStream,
        builder: (context, snap) {
          StateInside state = snap.data;

          return FlatButton(
              height: _height,
              padding: EdgeInsets.zero,
              onPressed: _action(snap.data),
              child: SizedBox(
                  height: _height,
                  child: state?.stateInside ??
                      _StateInsideWidget(
                          false,
                          _StateInsideDecoration.differenceBtw(false),
                          Container())));
        });
  }

  Function _action(T data) {
    bool enable = data.enable ?? false;
    if (!enable) {
      return null;
    }
    return () {
      actionStreamController.add(data);
    };
  }
}

class StateInside {
  /// 是否可以点击
  final bool enable;

  StateInside(this.enable, this.description,
      {Decoration decoration, Widget stateInside})
      : this.decoration =
            decoration ?? _StateInsideDecoration.differenceBtw(enable);

  /// 背景
  Decoration decoration;

  /// 状态描述
  Widget description;

  /// 整体widget
  Widget get stateInside => _StateInsideWidget(enable, decoration, description);
}

class _StateInsideWidget extends StatelessWidget {
  _StateInsideWidget(this.enable, this.decoration, this.description);

  final Decoration decoration;

  final Widget description;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: EdgeInsets.zero,
      decoration: decoration,
      child: _body(),
    );
  }

  Widget _body() {
    switch (enable) {
      case false:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AlwaysAnimationIndictor(),
            SizedBox(
              width: 12,
            ),
            description,
          ],
        );
      case true:
        return Center(child: description);
    }
    return Container();
  }

  final bool enable;
}

class _AlwaysAnimationIndictor extends CupertinoActivityIndicator {
  _AlwaysAnimationIndictor() : super(animating: true);
}

class _StateInsideDecoration {
  static Decoration differenceBtw(bool enable) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: enable ? _EnableStateGradient() : _DisableStateGradient());
  }
}

class _DisableStateGradient extends LinearGradient {
  _DisableStateGradient()
      : super(colors: [
          Color.fromARGB(50, 25, 213, 174),
          Color.fromARGB(50, 0, 191, 164),
        ]);
}

class _EnableStateGradient extends LinearGradient {
  _EnableStateGradient()
      : super(colors: [
          Color.fromARGB(1000, 25, 213, 174),
          Color.fromARGB(1000, 0, 191, 164),
        ]);
}
