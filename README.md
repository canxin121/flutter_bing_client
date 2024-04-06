════════ Exception caught by rendering library ═════════════════════════════════
The following assertion was thrown during performResize():
Vertical viewport was given unbounded height.
Viewports expand in the scrolling direction to fill their container. In this case, a vertical viewport was given an unlimited amount of vertical space in which to expand. This situation typically happens when a scrollable widget is nested inside another scrollable widget.
If this widget is always nested in a scrollable widget there is no need to use a viewport because there will always be enough vertical space for the children. In this case, consider using a Column or Wrap instead. Otherwise, consider using a CustomScrollView to concatenate arbitrary slivers into a single scrollable.

The relevant error-causing widget was:
    MarkdownWidget MarkdownWidget:file:///D:/Git/flutter_bing_client/lib/comps/chat_page.dart:130:15

When the exception was thrown, this was the stack:
#0      debugCheckHasBoundedAxis.<anonymous closure> (package:flutter/src/rendering/debug.dart:337:13)
#1      debugCheckHasBoundedAxis (package:flutter/src/rendering/debug.dart:396:4)
#2      RenderViewport.computeDryLayout (package:flutter/src/rendering/viewport.dart:1416:12)
#52     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#53     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:52:11)
#54     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:809:43)
#55     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:904:32)
#56     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#57     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#58     RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:239:12)
#59     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#60     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#61     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#62     RenderCustomPaint.performLayout (package:flutter/src/rendering/custom_paint.dart:569:11)
#63     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#64     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#65     RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:239:12)
#66     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#67     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#68     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#69     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#70     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#71     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#72     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#73     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#74     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:52:11)
#75     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:809:43)
#76     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:904:32)
#77     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#78     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#79     RenderConstrainedBox.performLayout (package:flutter/src/rendering/proxy_box.dart:280:14)
#80     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#81     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#82     ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:52:11)
#83     RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:809:43)
#84     RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:904:32)
#85     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#86     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#87     RenderPositionedBox.performLayout (package:flutter/src/rendering/shifted_box.dart:456:14)
#88     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#89     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#90     RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:239:12)
#91     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#92     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#93     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#94     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#95     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#96     RenderPositionedBox.performLayout (package:flutter/src/rendering/shifted_box.dart:456:14)
#97     RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#98     RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#99     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#100    _RenderCustomClip.performLayout (package:flutter/src/rendering/proxy_box.dart:1440:11)
#101    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#102    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#103    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#104    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#105    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#106    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#107    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#108    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#109    RenderSliverMultiBoxAdaptor.insertAndLayoutChild (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:489:13)
#110    RenderSliverList.performLayout.advance (package:flutter/src/rendering/sliver_list.dart:239:19)
#111    RenderSliverList.performLayout (package:flutter/src/rendering/sliver_list.dart:281:12)
#112    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#113    RenderSliverEdgeInsetsPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:139:12)
#114    RenderSliverPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:361:11)
#115    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#116    RenderViewportBase.layoutChildSequence (package:flutter/src/rendering/viewport.dart:601:13)
#117    RenderViewport._attemptLayout (package:flutter/src/rendering/viewport.dart:1555:12)
#118    RenderViewport.performLayout (package:flutter/src/rendering/viewport.dart:1464:20)
#119    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#120    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#121    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#122    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#123    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#124    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#125    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#126    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#127    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#128    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#129    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#130    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#131    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#132    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#133    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#134    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#135    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#136    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#137    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#138    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#139    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#140    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#141    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#142    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#143    RenderCustomPaint.performLayout (package:flutter/src/rendering/custom_paint.dart:569:11)
#144    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#145    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#146    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#147    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#148    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#149    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#150    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#151    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#152    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#153    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#154    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#155    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#156    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#157    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#158    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#159    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#160    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#161    _RenderLayoutBuilder.performLayout (package:flutter/src/widgets/layout_builder.dart:333:14)
#162    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#163    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#164    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#165    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#166    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#167    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#168    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#169    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#170    ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:52:11)
#171    RenderFlex._computeSizes (package:flutter/src/rendering/flex.dart:869:45)
#172    RenderFlex.performLayout (package:flutter/src/rendering/flex.dart:904:32)
#173    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#174    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#175    RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:105:21)
#176    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#177    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#178    ChildLayoutHelper.layoutChild (package:flutter/src/rendering/layout_helper.dart:52:11)
#179    RenderStack._computeSize (package:flutter/src/rendering/stack.dart:582:43)
#180    RenderStack.performLayout (package:flutter/src/rendering/stack.dart:609:12)
#181    RenderObject.layout (package:flutter/src/rendering/object.dart:2575:7)
#182    RenderBox.layout (package:flutter/src/rendering/box.dart:2389:11)
#183    MultiChildLayoutDelegate.layoutChild (package:flutter/src/rendering/custom_layout.dart:173:12)
#184    _ScaffoldLayout.performLayout (package:flutter/src/material/scaffold.dart:1063:7)
#185    MultiChildLayoutDelegate._callPerformLayout (package:flutter/src/rendering/custom_layout.dart:237:7)
#186    RenderCustomMultiChildLayoutBox.performLayout (package:flutter/src/rendering/custom_layout.dart:404:14)
#187    RenderObject._layoutWithoutResize (package:flutter/src/rendering/object.dart:2414:7)
#188    PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1051:18)
#189    PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1064:15)
#190    RendererBinding.drawFrame (package:flutter/src/rendering/binding.dart:582:23)
#191    WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:1048:13)
#192    RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:448:5)
#193    SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1386:15)
#194    SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1311:9)
#195    SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1169:5)
#196    _invoke (dart:ui/hooks.dart:312:13)
#197    PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:399:5)
#198    _drawFrame (dart:ui/hooks.dart:283:31)

The following RenderObject was being processed when the exception was fired: RenderViewport#3179e NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
    needs compositing
    parentData: <none> (can use size)
    constraints: BoxConstraints(0.0<=w<=410.0, 0.0<=h<=Infinity)
    size: MISSING
    axisDirection: down
    crossAxisDirection: right
    offset: ScrollPositionWithSingleContext#22cf7(offset: 0.0, range: null..null, viewport: null, ScrollableState, ClampingScrollPhysics -> RangeMaintainingScrollPhysics, IdleScrollActivity#4bf88, ScrollDirection.idle)
    anchor: 0.0
    center child: RenderSliverPadding#4c7c3 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
        parentData: paintOffset=Offset(0.0, 0.0)
        constraints: MISSING
        geometry: null
        padding: EdgeInsets.zero
        textDirection: ltr
        child: RenderSliverList#1076a NEEDS-LAYOUT NEEDS-PAINT
            parentData: paintOffset=Offset(0.0, 0.0)
            constraints: MISSING
            geometry: null
            no children current live
RenderObject: RenderViewport#3179e NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
    needs compositing
    parentData: <none> (can use size)
    constraints: BoxConstraints(0.0<=w<=410.0, 0.0<=h<=Infinity)
    size: MISSING
    axisDirection: down
    crossAxisDirection: right
    offset: ScrollPositionWithSingleContext#22cf7(offset: 0.0, range: null..null, viewport: null, ScrollableState, ClampingScrollPhysics -> RangeMaintainingScrollPhysics, IdleScrollActivity#4bf88, ScrollDirection.idle)
    anchor: 0.0
    center child: RenderSliverPadding#4c7c3 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
        parentData: paintOffset=Offset(0.0, 0.0)
        constraints: MISSING
        geometry: null
        padding: EdgeInsets.zero
        textDirection: ltr
        child: RenderSliverList#1076a NEEDS-LAYOUT NEEDS-PAINT
            parentData: paintOffset=Offset(0.0, 0.0)
            constraints: MISSING
            geometry: null
            no children current live
════════════════════════════════════════════════════════════════════════════════

════════ Exception caught by rendering library ═════════════════════════════════
RenderBox was not laid out: RenderViewport#3179e NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
'package:flutter/src/rendering/box.dart':
Failed assertion: line 1972 pos 12: 'hasSize'
The relevant error-causing widget was:
════════════════════════════════════════════════════════════════════════════════
