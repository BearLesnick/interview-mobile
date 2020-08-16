import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final int maxLength;
  final void Function(String) onSubmitted;
  final TextEditingController controller;

  const TextInputWidget(
      {Key key, this.controller, this.maxLength = 60, this.onSubmitted})
      : super(key: key);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  FocusNode _focusNode = FocusNode();

  bool shouldDisplayClearButton = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.length != 0) {
      shouldDisplayClearButton = true;
    }
    subscribeOnController();
  }

  @override
  void didUpdateWidget(TextInputWidget oldWidget) {
    if (oldWidget.controller != this.widget.controller) {
      oldWidget.controller?.removeListener(buttonDisplayingListener);
      subscribeOnController();
    }
    super.didUpdateWidget(oldWidget);
  }

  void subscribeOnController() {
    widget.controller.addListener(buttonDisplayingListener);
  }

  void buttonDisplayingListener() {
    if (widget.controller.text.length != 0 && !shouldDisplayClearButton) {
      setState(() {
        shouldDisplayClearButton = true;
      });
    } else if (widget.controller.text.length == 0 && shouldDisplayClearButton) {
      setState(() {
        shouldDisplayClearButton = false;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(buttonDisplayingListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            decoration: InputDecoration(focusColor: Colors.black),
            maxLength: 60,
            onSubmitted: widget.onSubmitted,
          ),
          if (shouldDisplayClearButton)
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    widget.controller.text = "";
                    _focusNode.unfocus();
                  },
                ))
        ],
      ),
    );
  }
}
