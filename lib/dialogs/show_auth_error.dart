import 'package:flutter/material.dart' show BuildContext;
import 'package:okello_bill_tool/dialogs/generic_dialog.dart';

import 'auth_error.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
