import 'package:flutter/material.dart';

class FindingYourLocationDialog extends StatelessWidget {
  const FindingYourLocationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 250.0,
          maxHeight: 250.0,
          maxWidth: 550.0,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LinearProgressIndicator(),
              Flexible(
                child: Center(
                  child: Text(
                    'Αναζήτηση τοποθεσίας, παρακαλώ περίμενε!',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
