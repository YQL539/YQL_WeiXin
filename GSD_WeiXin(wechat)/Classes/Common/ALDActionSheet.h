//
//  ALDActionSheet.h
//  wash
//
//  Created by weixikeji on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@class ALDActionSheet;

@protocol ALDActionSheetDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(ALDActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ALDActionSheet : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id <ALDActionSheetDelegate> delegate;

/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<ALDActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
