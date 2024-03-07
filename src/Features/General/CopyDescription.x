#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../../modules/JGProgressHUD/JGProgressHUD.h"

%hook IGCoreTextView
- (id)initWithWidth:(CGFloat)width {
    self = %orig;
    if ([BHIManager copyDecription]) {
        [self addHandleLongPress];
    }
    return self;
}
%new - (void)addHandleLongPress {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];
}

%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Copy text to system clipboard
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.text;

        // Notify user
        JGProgressHUD *HUD = [[JGProgressHUD alloc] init];
        HUD.textLabel.text = @"Copied text to clipboard!";
        HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        [HUD showInView:topMostController().view];
        [HUD dismissAfterDelay:2.0];
    }
}
%end