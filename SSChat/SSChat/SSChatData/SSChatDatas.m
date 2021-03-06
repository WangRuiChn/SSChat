//
//  SSChatDatas.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//


#import "SSChatDatas.h"
#import <UserNotifications/UserNotifications.h>
#import "SSChatTime.h"
#import "SSNotificationManager.h"

@implementation SSChatDatas

-(instancetype)init{
    if(self = [super init]){
        _timelInterval = -1;
    }
    return self;
}



//处理消息的时间显示
-(void)dealTimeWithMessageModel:(SSChatMessage *)model{
    SSChatMessage *message = model;
    CGFloat interval = (_timelInterval - model.timestamp) / 1000;
    if (_timelInterval < 0 || interval > 60 || interval < -60) {
        message.messageTime = [SSChatTime formattedTimeFromTimeInterval:model.timestamp];
        _timelInterval = model.timestamp;
        message.showTime = YES;
    }
}



//将环信的消息模型转换成本地模型
-(SSChatMessage *)getModelWithMessage:(EMMessage *)message{
    
   
    SSChatMessage *chatMessage = [SSChatMessage new];
    chatMessage.conversationId = message.messageId;
    chatMessage.timestamp = message.timestamp;
    [self dealTimeWithMessageModel:chatMessage];
    
    if(message.direction == EMMessageDirectionSend){
        chatMessage.messageFrom = SSChatMessageFromMe;
        chatMessage.backImgString = @"icon_qipao1";
        
        chatMessage.voiceImg = [UIImage imageNamed:@"chat_animation_white3"];
        chatMessage.voiceImgs =
        @[[UIImage imageNamed:@"chat_animation_white1"],
          [UIImage imageNamed:@"chat_animation_white2"],
          [UIImage imageNamed:@"chat_animation_white3"]];
    }
    else{
        chatMessage.messageFrom = SSChatMessageFromOther;
        chatMessage.backImgString = @"icon_qipao2";
        
        chatMessage.voiceImg = [UIImage imageNamed:@"chat_animation3"];
        chatMessage.voiceImgs =
        @[[UIImage imageNamed:@"chat_animation1"],
          [UIImage imageNamed:@"chat_animation2"],
          [UIImage imageNamed:@"chat_animation3"]];
    }
    
    chatMessage.message = message;
    EMMessageBody *msgBody = message.body;
    
    //其他消息
    switch (msgBody.type) {
        case EMMessageBodyTypeText:{

            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            
            chatMessage.textColor   = SSChatTextColor;
            chatMessage.cellString  =  SSChatTextCellId;
            chatMessage.messageType = SSChatMessageTypeText;
            chatMessage.textString  = textBody.text;
            
        }
            break;
        case EMMessageBodyTypeImage:{
            
            chatMessage.cellString =  SSChatImageCellId;
            chatMessage.messageType = SSChatMessageTypeImage;
            chatMessage.imageBody = (EMImageMessageBody *)message.body;
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
            
            chatMessage.cellString =  SSChatMapCellId;
        }
            break;
        case EMMessageBodyTypeVoice:        {

            chatMessage.messageType = SSChatMessageTypeVoice;
            chatMessage.cellString =  SSChatVoiceCellId;
            chatMessage.voiceBody = (EMVoiceMessageBody *)msgBody;
        }
            break;
        case EMMessageBodyTypeVideo:{
            
            chatMessage.messageType = SSChatMessageTypeVideo;
            chatMessage.cellString =  SSChatVideoCellId;
            chatMessage.videoBody = (EMVideoMessageBody *)msgBody;
        }
            break;
        case EMMessageBodyTypeFile:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,body.downloadStatus);
            
            chatMessage.cellString =  SSChatVoiceCellId;
        }
            break;
            
        default:
            break;
    }
    
    return chatMessage;
}



//将环信模型转换成 SSChatMessagelLayout
-(SSChatMessagelLayout *)getLayoutWithMessage:(EMMessage *)message{
    
   
    SSChatMessage *chatMessage = [self getModelWithMessage:message];
    return [[SSChatMessagelLayout alloc]initWithMessage:chatMessage];
}


//加载所有的消息并转换成layout数组
-(NSMutableArray *)getLayoutsWithMessages:(NSArray *)aMessages conversationId:(NSString *)conversationId{
    
    NSMutableArray *array = [NSMutableArray new];
    for(EMMessage *message in aMessages){
        
        if([message.conversationId isEqualToString:conversationId]){
            
            [self setMessagesAsReadWithMessage:message type:EMConversationTypeChat];
            SSChatMessagelLayout *layout = [self getLayoutWithMessage:message];
            [array addObject:layout];
        }
    }
    
    return  array;
}


//设置已读
-(void)setMessagesAsReadWithMessage:(EMMessage *)message type:(EMConversationType)type{
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:message.conversationId type:type createIfNotExist:YES];
    [conversation markMessageAsReadWithId:message.messageId error:nil];
    [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:^(EMMessage *aMessage, EMError *aError) {
        [self sendNotifCation:NotiMessageChange];
    }];
    
}




@end
