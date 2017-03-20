//
//  SDContactAddController.m
//  GSD_WeiXin(wechat)
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "SDContactAddController.h"
#import "ALDActionSheet.h"

@interface SDContactAddController ()<UITextFieldDelegate,ALDActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak) UIImageView *oneImage;
@property (nonatomic,weak) UITextField *oneText;
@property (nonatomic,strong) NSMutableDictionary *dictList;

@end

@implementation SDContactAddController

- (NSMutableDictionary *)dictList
{
    if (_dictList == nil) {
        _dictList = [NSMutableDictionary dictionary];
    }
    return _dictList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"朋友设置";
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+25, screenW, 88)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneoneDiv];
    
    UIView *onetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 87.5, screenW, 0.5)];
    onetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:onetwoDiv];
    
    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [oneBtn addTarget:self action:@selector(oneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:oneBtn];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    oneLabel.text = @"头像";
    oneLabel.font = [UIFont systemFontOfSize:15];
    oneLabel.textColor = [UIColor blackColor];
    [oneBtn addSubview:oneLabel];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    right.image = [UIImage imageNamed:@"jiantou"];
    [oneBtn addSubview:right];
    
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(screenW - 20 -7 - 15 - 32, 6, 32, 32)];
    [oneBtn addSubview:oneImage];
    self.oneImage = oneImage;
    
    UIView *oneDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW -15, 0.5)];
    oneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneDiv];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, screenW *0.5, 44)];
    twoLabel.text = @"昵称";
    twoLabel.font = [UIFont systemFontOfSize:15];
    twoLabel.textColor = [UIColor blackColor];
    [oneView addSubview:twoLabel];
    
    UITextField *oneText = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, screenW - 20, 44)];
    oneText.placeholder = @"请输入";
    oneText.delegate = self;
    oneText.returnKeyType = UIReturnKeyDone;
    oneText.font = [UIFont systemFontOfSize:15];
    oneText.textColor = [UIColor colorWithHexString:@"#999999"];
    [oneText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    oneText.textAlignment = NSTextAlignmentRight;
    [oneView addSubview:oneText];
    self.oneText = oneText;
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(oneView.frame) + 25;
    UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    overBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [overBtn addTarget:self action:@selector(overBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [overBtn.layer setMasksToBounds:YES];
    [overBtn.layer setCornerRadius:5];
    [self.view addSubview:overBtn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.oneText resignFirstResponder];
    return YES;
}

//朋友头像
- (void)oneBtnClick
{
    //推出我的个人信息拍照
    ALDActionSheet *sheet = [[ALDActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从相册选择", nil];
    //显示出来
    [sheet show];
    
}

-(void)actionSheet:(ALDActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            //拍照
            [self takePhoto];
            break;
        case 2:
            //从相册选择
            [self localPhoto];
            break;
        default:
            break;
    }
}

-(void)localPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate    = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为照相机
        picker.sourceType = sourceType;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else {
        
    }
}

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.oneImage.image = image;
    self.dictList[@"picture"] = UIImagePNGRepresentation(image);
    //关闭相册界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成
- (void)overBtnClick
{
    if (self.dictList[@"picture"]&&self.oneText.text.length) {
        self.dictList[@"nickName"] = self.oneText.text;
        NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"tongxunlu"];
        NSMutableArray *userinfo = [NSMutableArray array];
        if (userList.count >0) {
             [userinfo addObjectsFromArray:userList];
        }
        [userinfo addObject:self.dictList];
        [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:@"tongxunlu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [WKProgressHUD popMessage:@"请选择头像,昵称" inView:self.view duration:1.5 animated:YES];
    }
}


@end
