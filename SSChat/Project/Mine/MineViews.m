//
//  MineViews.m
//  SSChat
//
//  Created by soldoros on 2019/4/10.
//  Copyright © 2019 soldoros. All rights reserved.
//

#import "MineViews.h"


//顶部个人信息
@implementation MineTopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _mLeftImgView = [UIImageView new];
        _mLeftImgView.bounds = CGRectMake(0, 0, 50, 50);
        _mLeftImgView.left = 15;
        _mLeftImgView.centerY = MineTopCellH * 0.5;
        _mLeftImgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_mLeftImgView];
        _mLeftImgView.image = [UIImage imageNamed:@"user_avatar_gray"];
        
        _mTitleLab = [UILabel new];
        _mTitleLab.bounds = makeRect(0, 0, 100, 30);
        _mTitleLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:_mTitleLab];
        _mTitleLab.font = makeBlodFont(18);
        
        _mDetailLab = [UILabel new];
        _mDetailLab.bounds = makeRect(0, 0, 100, 30);
        _mDetailLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:_mDetailLab];
        _mDetailLab.font = makeFont(16);
    }
    return self;
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    
    NSString *userName = dataDic[@"title"];
    NSString *nikcName = dataDic[@"detail"];
    
    if(nikcName.length == 0){
        _mTitleLab.text = userName;
        [_mTitleLab sizeToFit];
        _mTitleLab.left = _mLeftImgView.right + 15;
        _mTitleLab.bottom = MineTopCellH * 0.5 - 3;
        
        _mDetailLab.text = @"欢迎来到Hello体验中心！";
        _mDetailLab.font = makeFont(14);
        [_mDetailLab sizeToFit];
        _mDetailLab.left = _mLeftImgView.right + 17;
        _mDetailLab.top = MineTopCellH * 0.5 + 4;
    }else{
        _mTitleLab.text = nikcName;
        [_mTitleLab sizeToFit];
        _mTitleLab.left = _mLeftImgView.right + 15;
        _mTitleLab.bottom = MineTopCellH * 0.5 - 2;
        
        _mDetailLab.text = makeString(@"账号：", userName);
        _mDetailLab.font = makeFont(14);
        [_mDetailLab sizeToFit];
        _mDetailLab.left = _mLeftImgView.right + 16;
        _mDetailLab.top = MineTopCellH * 0.5 + 6;
    }
}


@end



//其他功能
@implementation MineCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
    
}


@end



//退出登录
@implementation MineLogOutCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.textLabel.textColor = TitleColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = makeFont(16);
    }
    return self;
    
}


@end



//个人信息cell
@implementation MineInformationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _mRightImgView = [UIImageView new];
        [self.contentView addSubview:_mRightImgView];
    }
    return self;
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    
    self.textLabel.text = dataDic[@"title"];
    self.textLabel.font = makeFont(16);
    self.textLabel.textColor = [UIColor blackColor];
    
    //头像
    if(_indexPath.section == 0 && _indexPath.row == 0){
        self.accessoryType = UITableViewCellAccessoryNone;
        _mRightImgView.hidden = NO;
        _mRightImgView.bounds = makeRect(0, 0, 60, 60);
        _mRightImgView.right = SCREEN_Width - 15;
        _mRightImgView.centerY = MineInformationCellH * 0.5;
        _mRightImgView.image = [UIImage imageNamed:dataDic[@"detail"]];
    }
    //二维码
    else if (_indexPath.row == 3){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _mRightImgView.hidden = NO;
        _mRightImgView.bounds = makeRect(0, 0, 30, 30);
        _mRightImgView.right = SCREEN_Width - 40;
        _mRightImgView.centerY = MineInformationCellH2 * 0.5;
        _mRightImgView.image = [UIImage imageNamed:dataDic[@"detail"]];
    }
    else{
        if(_indexPath.row == 2){
            self.accessoryType = UITableViewCellAccessoryNone;
        }else{
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        _mRightImgView.hidden = YES;
        self.detailTextLabel.text = dataDic[@"detail"];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.font = makeFont(14);
    }
}

@end



//系统设置cell
@implementation MineSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = makeFont(16);
        
        _mSwitch = [[UISwitch alloc]init];
        _mSwitch.bounds = makeRect(0, 0, 50, 28);
        _mSwitch.backgroundColor = [UIColor whiteColor];
        _mSwitch.right = SCREEN_Width-20;
        _mSwitch.centerY = MineSwitchCellH*0.5;
        _mSwitch.on = NO;
        [_mSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview: _mSwitch];
        
    }
    return self;
}


//加我好友是否需要验证
-(void)switchAction:(UISwitch *)sender{
    
    makeUserAddVerification(sender.on);
}

//系统设置数据
-(void)setDataDic:(NSDictionary *)dataDic{
    
    if(self.indexPath.row==0){
        _mSwitch.hidden = NO;
        _mSwitch.on = [dataDic[@"detail"] boolValue];
        self.textLabel.text = dataDic[@"title"];
    }else{
        _mSwitch.hidden = YES;
        self.textLabel.text = dataDic[@"title"];
    }
}


@end
