#import "../../Manager.h"
#import "../../Utils.h"

%hook IGStoryViewerTapTarget
- (void)_didTap:(id)arg1 forEvent:(id)arg2 {
    if ([BHIManager stickerInteractConfirmation]) {
        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end