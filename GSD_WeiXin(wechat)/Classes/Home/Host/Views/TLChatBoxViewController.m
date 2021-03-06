//
//  TLChatBoxViewController.m
//  iOSAppTemplate
//
//  Created by libokun on 15/10/16.
//  Copyright (c) 2015年 lbk. All rights reserved.
//

#import "TLChatBoxViewController.h"
#import "TLChatBox.h"
#import "TLChatBoxMoreView.h"
#import "TLChatBoxFaceView.h"
#import "RedPacketViewController.h"
#import "TransformViewController.h"
#import "TimeViewController.h"
#import "VideoViewController.h"
@interface TLChatBoxViewController () <TLChatBoxDelegate, TLChatBoxFaceViewDelegate, TLChatBoxMoreViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;

@property (nonatomic, strong) TLChatBox *chatBox;
@property (nonatomic, strong) TLChatBoxMoreView *chatBoxMoreView;
@property (nonatomic, strong) TLChatBoxFaceView *chatBoxFaceView;

@end

@implementation TLChatBoxViewController

#pragma mark - LifeCycle
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.chatBox];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resignFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Public Methods
- (BOOL) resignFirstResponder
{
    if (self.chatBox.status != TLChatBoxStatusNothing && self.chatBox.status != TLChatBoxStatusShowVoice) {
        [self.chatBox resignFirstResponder];
        self.chatBox.status = (self.chatBox.status == TLChatBoxStatusShowVoice ? self.chatBox.status : TLChatBoxStatusNothing);
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
            }];
        }
    }
    return [super resignFirstResponder];
}

#pragma mark - TLChatBoxDelegate
- (void) chatBox:(TLChatBox *)chatBox sendTextMessage:(NSString *)textMessage
{
    TLMessage *message = [[TLMessage alloc] init];
    message.messageType = TLMessageTypeText;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.text = textMessage;
    message.date = [NSDate date];
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController: sendMessage:)]) {
        [_delegate chatBoxViewController:self sendMessage:message];
    }
}

- (void)chatBox:(TLChatBox *)chatBox changeChatBoxHeight:(CGFloat)height
{
    self.chatBoxFaceView.originY = height;
    self.chatBoxMoreView.originY = height;
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        float h = (self.chatBox.status == TLChatBoxStatusShowFace ? HEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height ) + height;
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: h];
    }
}

- (void) chatBox:(TLChatBox *)chatBox changeStatusForm:(TLChatBoxStatus)fromStatus to:(TLChatBoxStatus)toStatus
{
    if (toStatus == TLChatBoxStatusShowKeyboard) {      // 显示键盘
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatBoxFaceView removeFromSuperview];
            [self.chatBoxMoreView removeFromSuperview];
        });
        return;
    }
    else if (toStatus == TLChatBoxStatusShowVoice) {    // 显示语音输入按钮
        // 从显示更多或表情状态 到 显示语音状态需要动画
        if (fromStatus == TLChatBoxStatusShowMore || fromStatus == TLChatBoxStatusShowFace) {
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                }
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
            }];
        }
        else {
            [UIView animateWithDuration:0.1 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                }
            }];
        }
    }
    else if (toStatus == TLChatBoxStatusShowFace) {     // 显示表情面板
        if (fromStatus == TLChatBoxStatusShowVoice || fromStatus == TLChatBoxStatusNothing) {
            [self.chatBoxFaceView setOriginY:self.chatBox.curHeight];
            [self.view addSubview:self.chatBoxFaceView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                }
            }];
        }
        else {
            // 表情高度变化
            self.chatBoxFaceView.originY = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.chatBoxFaceView];
            [UIView animateWithDuration:0.3 animations:^{
                self.chatBoxFaceView.originY = self.chatBox.curHeight;
            } completion:^(BOOL finished) {
                [self.chatBoxMoreView removeFromSuperview];
            }];
            // 整个界面高度变化
            if (fromStatus != TLChatBoxStatusShowMore) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
        }
    }
    else if (toStatus == TLChatBoxStatusShowMore) {     // 显示更多面板
        if (fromStatus == TLChatBoxStatusShowVoice || fromStatus == TLChatBoxStatusNothing) {
            [self.chatBoxMoreView setOriginY:self.chatBox.curHeight];
            [self.view addSubview:self.chatBoxMoreView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                }
            }];
        }
        else {
            self.chatBoxMoreView.originY = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.chatBoxMoreView];
            [UIView animateWithDuration:0.3 animations:^{
                self.chatBoxMoreView.originY = self.chatBox.curHeight;
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
            }];
            
            if (fromStatus != TLChatBoxStatusShowFace) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
        }
    }
}

#pragma mark - TLChatBoxFaceViewDelegate
- (void) chatBoxFaceViewDidSelectedFace:(TLFace *)face type:(TLFaceType)type
{
    if (type == TLFaceTypeEmoji) {
        [self.chatBox addEmojiFace:face];
    }
}

- (void) chatBoxFaceViewDeleteButtonDown
{
    [self.chatBox deleteButtonDown];
}

- (void) chatBoxFaceViewSendButtonDown
{
    [self.chatBox sendCurrentMessage];
}

#pragma mark - TLChatBoxMoreViewDelegate
- (void) chatBoxMoreView:(TLChatBoxMoreView *)chatBoxMoreView didSelectItem:(TLChatBoxItem)itemType
{
    if (itemType == TLChatBoxItemAlbum) {            // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
    else if (itemType == TLChatBoxItemCamera) {       // 拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];//初始化
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker setDelegate:self];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前设备不支持拍照。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }else if (itemType == TLChatBoxItemRedPacket) {
        RedPacketViewController *redController = [[RedPacketViewController alloc]init];
        redController.didFinishSetRedPacketBlock = ^(NSString *moneyNum,NSString *moneyState){
            TLMessage *message = [[TLMessage alloc] init];
            message.messageType = TLMessageTypeRedPacket;
            message.date = [NSDate date];
            message.RedPacketString = moneyState;
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_delegate chatBoxViewController:self sendMessage:message];
            }
        };
        [self.navigationController pushViewController:redController animated:YES];
    }else if (itemType == TLChatBoxItemTransform) {
        TransformViewController *transformController = [[TransformViewController alloc]init];
        transformController.didFinishSetTransformBlock = ^(NSString *moneyNum,NSString *moneyState,NSString *starTime,NSString *endTime){
            TLMessage *message = [[TLMessage alloc] init];
            message.messageType = TLMessageTypeTransfer;
            message.date = [NSDate date];
            message.transformString = moneyState;
            message.transformNum = moneyNum;
            message.transformStarTime = starTime;
            message.transformEndTime = endTime;
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_delegate chatBoxViewController:self sendMessage:message];
            }
//            NSLog(@"转账block发给我的回传%@=%@=%@=%@=%@",message,moneyNum,moneyState,starTime,endTime);
        };

        [self.navigationController pushViewController:transformController animated:YES];
    }else if (itemType == TLChatBoxItemCards) {
        NSLog(@"卡券-时间");
        TimeViewController *timeController = [[TimeViewController alloc]init];
        timeController.didFinishSetTimeBlock = ^(NSString *time){
            TLMessage *message = [[TLMessage alloc] init];
            message.messageType = TLMessageTypeTime;
            message.date = [NSDate date];
            message.dateString = time;
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_delegate chatBoxViewController:self sendMessage:message];
            }
            NSLog(@"时间block发给我的回传%@",time);
        };
        
        [self.navigationController pushViewController:timeController animated:YES];
    }else if (itemType == TLChatBoxItemVoice) {
        NSLog(@"语音");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入时间" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.placeholder = @"请输入时间(1-60)";
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *textfields = alertController.textFields;
            UITextField *numfield = textfields[0];
            NSUInteger iTime = [numfield.text integerValue];
            NSLog(@"我发送时间为%lu",(unsigned long)iTime);
            TLMessage *message = [[TLMessage alloc] init];
            message.ownerTyper = TLMessageOwnerTypeSelf;
            message.messageType = TLMessageTypeVoice;
            message.date = [NSDate date];
            message.voiceSeconds = iTime;
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_delegate chatBoxViewController:self sendMessage:message];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (itemType == TLChatBoxItemPersonCard) {
        NSLog(@"撤回");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择下列操作" message:@"对方撤回请切换角色再点击" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"撤回消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            TLMessage *message = [[TLMessage alloc] init];
            message.ownerTyper = TLMessageOwnerTypeSelf;
            message.messageType = TLMessageTypeCheHui;
            message.date = [NSDate date];
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_delegate chatBoxViewController:self sendMessage:message];
            }

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (itemType == TLChatBoxItemVideo) {
        
        VideoViewController *redController = [[VideoViewController alloc]init];
        redController.model = _model;
        redController.didFinishSetVideoBlock = ^(NSString *minutes,NSString *seconds){
            TLMessage *message = [[TLMessage alloc] init];
            message.messageType = TLMessageTypeVideo;
            message.date = [NSDate date];
            message.videoMinutes= minutes;
            message.videoSeconds = seconds;
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_delegate chatBoxViewController:self sendMessage:message];
            }
        };
        [self.navigationController pushViewController:redController animated:YES];
    }
    else if (itemType == TLChatBoxItemSwitchRole) {
        if (_delegate && [_delegate respondsToSelector:@selector(SwitchRole)]) {
            [_delegate SwitchRole];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"Did Selected Index Of ChatBoxMoreView: %d", (int)itemType] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)setVoiceTime:(NSInteger)ToTag{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入时间" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *numfield = textfields[0];
        numfield.keyboardType = UIKeyboardTypeDecimalPad;
        NSUInteger iTime = [numfield.text integerValue];
        NSLog(@"我发送时间为%lu",(unsigned long)iTime);
        TLMessage *message = [[TLMessage alloc] init];
        message.ownerTyper = ToTag;
        message.messageType = TLMessageTypeVoice;
        message.date = [NSDate date];
        message.voiceSeconds = iTime;
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
            [_delegate chatBoxViewController:self sendMessage:message];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    UIImage *newImage = [image fixOrientation:image];
    UIImage *compressImage = [self compressImageToData:newImage];
        TLMessage *message = [[TLMessage alloc] init];
        message.messageType = TLMessageTypeImage;
        message.date = [NSDate date];
        message.picture = UIImagePNGRepresentation(compressImage);
//        NSLog(@"%@",message.imagePath);
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
            [_delegate chatBoxViewController:self sendMessage:message];
        }
    //关闭相册界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//图片压缩成200k
-(UIImage *)compressImageToData:(UIImage *)image
{
    NSData *dataImage = UIImageJPEGRepresentation(image, 1);
    
    if(dataImage.length > 500*1024)
    {
        image = [self scaleImage:image toScale:sqrt(1.f/(dataImage.length/(500.f*1024.f)))];
    }
    return image;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - Private Methods
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    if (_chatBox.status == TLChatBoxStatusShowFace || _chatBox.status == TLChatBoxStatusShowMore) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_chatBox.status == TLChatBoxStatusShowKeyboard && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        return;
    }
    else if ((_chatBox.status == TLChatBoxStatusShowFace || _chatBox.status == TLChatBoxStatusShowMore) && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: self.keyboardFrame.size.height + self.chatBox.curHeight];
    }
}

#pragma mark - Getter
- (TLChatBox *) chatBox
{
    if (_chatBox == nil) {
        _chatBox = [[TLChatBox alloc] initWithFrame:CGRectMake(0, 0, screenW, HEIGHT_TABBAR)];
        [_chatBox setDelegate:self];
    }
    return _chatBox;
}

- (TLChatBoxMoreView *) chatBoxMoreView
{
    if (_chatBoxMoreView == nil) {
        _chatBoxMoreView = [[TLChatBoxMoreView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, screenW, HEIGHT_CHATBOXVIEW)];
        [_chatBoxMoreView setDelegate:self];
        
        TLChatBoxMoreItem *photosItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"照片"
                                                                                imageName:@"sharemore_pic"];
        TLChatBoxMoreItem *takePictureItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"拍摄"
                                                                                     imageName:@"sharemore_video"];
        TLChatBoxMoreItem *videoItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"切换角色"
                                                                               imageName:@"sharemore_sight"];
        TLChatBoxMoreItem *videoCallItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"视频聊天"
                                                                                   imageName:@"sharemore_videovoip"];
        TLChatBoxMoreItem *giftItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"红包"
                                                                              imageName:@"sharemore_wallet"];
        TLChatBoxMoreItem *transferItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"转账"
                                                                                  imageName:@"sharemorePay"];
        TLChatBoxMoreItem *positionItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"位置"
                                                                                  imageName:@"sharemore_location"];
        TLChatBoxMoreItem *favoriteItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"收藏"
                                                                                  imageName:@"sharemore_myfav"];
        TLChatBoxMoreItem *businessCardItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"名片-撤销"
                                                                                      imageName:@"sharemore_friendcard" ];
//        TLChatBoxMoreItem *interphoneItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"实时对讲机"
//                                                                                    imageName:@"sharemore_wxtalk" ];
        TLChatBoxMoreItem *voiceItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"语音输入"
                                                                    imageName:@"sharemore_voiceinput"];
        TLChatBoxMoreItem *cardsItem = [TLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"卡券-时间"
                                                                               imageName:@"sharemore_wallet"];
        [_chatBoxMoreView setItems:[[NSMutableArray alloc] initWithObjects:photosItem, takePictureItem, videoCallItem, positionItem, giftItem, transferItem, businessCardItem, voiceItem, favoriteItem, cardsItem,videoItem, nil]];
    }
    return _chatBoxMoreView;
}

- (TLChatBoxFaceView *) chatBoxFaceView
{
    if (_chatBoxFaceView == nil) {
        _chatBoxFaceView = [[TLChatBoxFaceView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, screenW, HEIGHT_CHATBOXVIEW)];
        [_chatBoxFaceView setDelegate:self];
    }
    return _chatBoxFaceView;
}

@end
