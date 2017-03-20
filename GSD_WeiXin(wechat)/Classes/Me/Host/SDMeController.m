//
//  SDMeController.m
//  GSD_WeiXin(wechat)
//
//  Created by apple on 17/3/19.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "SDMeController.h"
#import "ALDActionSheet.h"
#import "SDNameModel.h"

@interface SDMeController ()<UITextFieldDelegate,ALDActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak) UIImageView *oneImage;
@property (nonatomic,weak) UITextField *oneText;
@property (nonatomic,weak) UITextField *twoText;
@property (nonatomic,strong) NSMutableDictionary *meDic;

@end

@implementation SDMeController

- (NSMutableDictionary *)meDic
{
    if (_meDic == nil) {
        _meDic = [NSMutableDictionary dictionary];
    }
    return _meDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    //标题
    self.title= @"个人信息";
    //界面布局
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+25, screenW, 132)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneoneDiv];
    
    UIView *onetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, screenW, 0.5)];
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
    twoLabel.text = @"朋友昵称";
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
    
    UIView *twoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 87.5, screenW -15, 0.5)];
    twoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:twoDiv];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 88, screenW *0.5, 44)];
    threeLabel.text = @"微信号";
    threeLabel.font = [UIFont systemFontOfSize:15];
    threeLabel.textColor = [UIColor blackColor];
    [oneView addSubview:threeLabel];
    
    UITextField *twoText = [[UITextField alloc] initWithFrame:CGRectMake(0, 88, screenW - 20, 44)];
    twoText.placeholder = @"请输入";
    twoText.delegate = self;
    twoText.returnKeyType = UIReturnKeyDone;
    twoText.font = [UIFont systemFontOfSize:15];
    twoText.textColor = [UIColor colorWithHexString:@"#999999"];
    [twoText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    twoText.textAlignment = NSTextAlignmentRight;
    [oneView addSubview:twoText];
    self.twoText = twoText;
    
    CGFloat overBtnY = CGRectGetMaxY(oneView.frame) + 25;
    UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    overBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [overBtn addTarget:self action:@selector(overBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [overBtn.layer setMasksToBounds:YES];
    [overBtn.layer setCornerRadius:5];
    [self.view addSubview:overBtn];
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    if (userDic.count) {
        SDNameModel *model = [SDNameModel mj_objectWithKeyValues:userDic];
        self.meDic[@"picture"] = model.picture;
        self.oneImage.image = [UIImage imageWithData:model.picture];
        self.oneText.text = model.nickName;
        self.twoText.text = model.weixin;
    }
}

- (void)overBtnClick
{
    if (self.meDic[@"picture"]&&self.oneText.text.length>0&&self.twoText.text.length>0) {
        self.meDic[@"nickName"] = self.oneText.text;
        self.meDic[@"weixin"] = self.twoText.text;
        [[NSUserDefaults standardUserDefaults] setObject:self.meDic forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [WKProgressHUD popMessage:@"请选择头像和昵称和微信号" inView:self.view duration:1.5 animated:YES];
    }
}

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
    self.meDic[@"picture"] = UIImagePNGRepresentation(image);
    //关闭相册界面
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
