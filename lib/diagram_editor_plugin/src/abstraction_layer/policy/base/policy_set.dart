
import '../../../../diagram_editor.dart';
import '../base_policy_set.dart';

/// Fundamental policy set. Your policy set should extend [PolicySet].
class PolicySet extends BasePolicySet
    with
        InitPolicy,
        CanvasPolicy,
        ComponentPolicy,
        ComponentDesignPolicy,
        LinkPolicy,
        LinkJointPolicy,
        LinkAttachmentPolicy,
        LinkWidgetsPolicy,
        CanvasWidgetsPolicy,
        ComponentWidgetsPolicy {}
