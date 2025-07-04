import 'package:camera/camera.dart';
import 'package:camra/model/camra_manager.dart';
import 'package:camra/model/camra_state.dart';
import 'package:flutter/material.dart';

class Camra extends StatefulWidget {
  final CamraManager cameraManager;

  final Widget Function(BuildContext)? errorBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final Widget Function(BuildContext)? bottomBarBuilder;

  final Future<void> Function(XFile)? onPhotoTaken;

  const Camra({
    super.key,
    required this.cameraManager,
    this.errorBuilder,
    this.loadingBuilder,
    this.bottomBarBuilder,
    this.onPhotoTaken,
  });

  @override
  State<Camra> createState() => _CamraState();
}

class _CamraState extends State<Camra> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<CamraState>(
        valueListenable: widget.cameraManager.state,
        builder: (context, state, _) {
          if (state.error != null) {
            return Center(child: Text("Error: ${state.error}"));
          }

          if (!state.isReady) {
            return widget.loadingBuilder?.call(context) ??
                const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              AspectRatio(
                aspectRatio: 1 / state.controller!.value.aspectRatio,
                child: CameraPreview(state.controller!),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.bottomBarBuilder?.call(context),
              ),
            ].nonNulls.toList(),
          );
        },
      ),
    );
  }
}

/// Widget that takes a picture
class CamraButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isEnabled;

  const CamraButton({
    super.key,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  State<CamraButton> createState() => _CamraButtonState();
}

class _CamraButtonState extends State<CamraButton> {
  bool isTapping = false;

  void onTap() {
    if (!widget.isEnabled) return;
    widget.onTap();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => isTapping = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => isTapping = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => isTapping = false);
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 80,
      maxWidth: 80,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest.shortestSide / 2 * 0.9;
          final innerSize = size - 2;
          return GestureDetector(
            onTap: onTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: CircleAvatar(
              radius: size,
              backgroundColor: Colors.white,
              child: isTapping
                  ? SizedBox.square(
                      dimension: innerSize,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
