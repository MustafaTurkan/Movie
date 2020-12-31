import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'field_button.dart';

class ScanTextField extends StatefulWidget {
  const ScanTextField(
      {Key key,
      this.controller,
      this.focusNode,
      this.decoration = const DenseInputDecoration(),
      this.cursorColor,
      this.textInputAction,
      this.splashColor,
      this.onSubmitted,
      this.onClear,
      this.autofocus = false,
      this.clearAfterSubmmit = false})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final Color cursorColor;
  final Color splashColor;
  final TextInputAction textInputAction;
  final bool autofocus;
  final Function(String) onSubmitted;
  final VoidCallback onClear;
  final bool clearAfterSubmmit;

  @override
  _ScanTextFieldState createState() => _ScanTextFieldState();
}

class _ScanTextFieldState extends State<ScanTextField> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _controller;
  FocusNode _focusNode;

  bool _showClearButton;
  TextEditingController get _effectiveController => widget.controller ?? _controller;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  bool get _hasText => !_effectiveController.text.isNullOrEmpty();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveController.addListener(_onTextChanged);

    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    _showClearButton = _hasText && !widget.clearAfterSubmmit;
  }

  @override
  void didUpdateWidget(ScanTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = TextEditingController.fromValue(oldWidget.controller.value);
        _controller.addListener(_onTextChanged);
      } else {
        _showClearButton = !widget.controller.text.isNullOrEmpty() && !widget.clearAfterSubmmit;
        if (oldWidget.controller == null) {
          _controller.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _handleKey,
        child: Form(
          key: formKey,
          child: TextFormField(
              validator: RequiredValidator<String>(errorText: context.getLocalizer().requiredValue),
              focusNode: _effectiveFocusNode,
              textInputAction: widget.textInputAction,
              controller: _effectiveController,
              cursorColor: widget.cursorColor,
              decoration: widget.decoration.copyWith(suffixIcon: _buildInputSuffixButton()),
              onFieldSubmitted: _onSubmitted,
              autofocus: widget.autofocus),
        ));
  }

  void _onSubmitted(String value) {
    if (!formKey.currentState.validate()) {
      return;
    }
    widget.onSubmitted(value);
    if (widget.clearAfterSubmmit) {
      _effectiveController.clear();
    }
  }

  void _handleKey(RawKeyEvent event) {
    if ((event.runtimeType == RawKeyDownEvent) && (event.logicalKey == LogicalKeyboardKey.enter)) {
      _onSubmitted(_effectiveController.text);
    }
  }

  Widget _buildInputSuffixButton() {
    if (_showClearButton) {
      return FieldButton(
        iconData: AppIcons.close,
        onTab: () {
          _effectiveController.clear();
          if (widget.onClear != null) {
            widget.onClear();
          }
        },
      );
    }

    return null;
  }

  void _onTextChanged() {
    if (_showClearButton != (_hasText && !widget.clearAfterSubmmit)) {
      setState(() {
        _showClearButton = !_showClearButton;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }
}
