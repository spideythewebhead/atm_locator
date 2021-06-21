import 'package:app/value_observer.dart';
import 'package:flutter/material.dart';

class LocationSearchWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final VoidCallback onBack;
  final ValueChanged<double> onRadiusChanged;
  final double initialRadius;
  final VoidCallback onWrongLocation;
  final VoidCallback onSearch;

  const LocationSearchWidget({
    Key? key,
    this.scrollController,
    required this.onBack,
    required this.onRadiusChanged,
    required this.initialRadius,
    required this.onWrongLocation,
    required this.onSearch,
  }) : super(key: key);

  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final radius = ValueObserver(0.0);

  @override
  void initState() {
    super.initState();

    radius.value = widget.initialRadius;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.onRadiusChanged(radius.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                BackButton(
                  onPressed: widget.onBack,
                ),
                Expanded(
                  child: Text(
                    'Αναζήτηση με βάση την τοποθεσία',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<double>(
              valueListenable: radius,
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider.adaptive(
                      value: value,
                      onChanged: (v) {
                        radius.value = v.roundToDouble();
                        widget.onRadiusChanged(radius.value);
                      },
                      min: 1.0,
                      max: 30.0,
                      divisions: 30,
                      label: '$value χλμ',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text(
                          'Ακτίνα: ${value} χλμ',
                          style: theme.textTheme.caption,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Η θέση μου είναι λάθος!',
                      style: theme.textTheme.caption,
                    ),
                    onPressed: () => widget.onWrongLocation(),
                  ),
                  TextButton(
                    child: Text('Αναζήτηση'),
                    onPressed: widget.onSearch,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
