 
import 'package:flutter/material.dart';

import '../../../canvas_context/model/link_data.dart';
import '../base_policy_set.dart';

/// Allows you to add any widget to a link.
mixin LinkWidgetsPolicy on BasePolicySet {
  /// Allows you to add any widget to a link.
  ///
  /// You have [LinkData] here so you can customize the widgets to individual link.
  ///
  /// Recommendation: use Positioned as the root widget.
  List<Widget> showWidgetsWithLinkData(
      BuildContext context, LinkData linkData) {
    return [];
  }
}
