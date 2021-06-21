import 'package:flutter/material.dart';

class LocationRequestDialog extends StatelessWidget {
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  LocationRequestDialog({
    Key? key,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 250.0,
          maxWidth: 550.0,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/location-permission-image.jpg',
                height: 150.0,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Χρειάζομαι τα δικαιώματα τοποθεσίας, για να σου δείξω ποιά ATM είναι κοντά σου.',
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Η τοποθεσία σου δεν καταγράφεται και δεν αποθηκεύεται πουθενα!',
                  style: theme.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              TextButtonTheme(
                data: TextButtonThemeData(),
                child: ButtonBar(
                  buttonHeight: 36.0,
                  children: [
                    TextButton(
                      child: Text(
                        'Όχι, δεν θέλω!',
                        style: theme.textTheme.button?.copyWith(color: Colors.red),
                      ),
                      onPressed: onDecline,
                    ),
                    TextButton(
                      child: Text(
                        'Ναι!',
                        style: theme.textTheme.button,
                      ),
                      onPressed: onAccept,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
