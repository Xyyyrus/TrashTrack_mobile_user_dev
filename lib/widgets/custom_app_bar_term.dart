import 'package:flutter/material.dart';

class CustomAppBarTerm extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarTerm({
    Key? key,
    this.title,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.titleTextStyle,
    this.elevation = 0.0,
  }) : super(key: key);

  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final TextStyle? titleTextStyle;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.green,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: elevation,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16.0),
            ),
          ),
          child: Stack(
            children: [
              if (leading != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: leading, // Only show leading widget if provided
                ),
              Center(
                child: Text(
                  title ?? '',
                  style: titleTextStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (actions != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
