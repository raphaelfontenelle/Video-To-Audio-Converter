//
//  MainInterfaceController.m
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 02/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import "MainInterfaceController.h"
#import "AppController.h"

@import AVKit;
@import AVFoundation;

@interface MainInterfaceController()

@property (nonatomic, strong) AppController *appController;

@end

@implementation MainInterfaceController

/**
 *  Static variable used to keep the reference of AppController in the memory.
 */
static MainInterfaceController *_singletonMainInterfaceController;


+ (MainInterfaceController *)sharedMainInterfaceController
{
    if (!_singletonMainInterfaceController){
        
        _singletonMainInterfaceController = [[MainInterfaceController alloc] init];
    }
    
    return _singletonMainInterfaceController;
}

- (instancetype)init
{
    if (!_singletonMainInterfaceController){
        
        _singletonMainInterfaceController = [super init];
        
        //Init code goes here.
        
        self.appController = [AppController sharedAppController];
    }
    
    return _singletonMainInterfaceController;
}

- (IBAction)convertVideoToAudioButton:(id)sender
{
    /*
    __block NSURL *outputAudioURL = nil;
    
    [self.appController showOpenDialog:^(NSArray<NSURL *> *urlsList) {
        
        if (urlsList.count > 0){
            
            outputAudioURL = urlsList[0];
            
            NSLog(@"Output ULR: %@", outputAudioURL);
            
            NSString *inputVideo = @"/Volumes/MEDIA/Vídeos/Youtube/Clipes/David Guetta - Bang My Head (Official Video) feat Sia \\u0026 Fetty Wap.mp4";
            
            //NSString *inputVideoConverted = [inputVideo stringByReplacingOccurrencesOfString:@"\\u0026" withString:@"&"];
            
            NSURL *inputVideoURL = [[NSURL alloc] initFileURLWithPath:inputVideo];
            
            NSString *outputFileAudio =
            [inputVideoURL lastPathComponent];
            
            NSString *outputFileAudioRenamed = [outputFileAudio stringByReplacingOccurrencesOfString:@"\\u0026" withString:@"&"];
            
            NSURL *outputAudioFileURL = [outputAudioURL URLByAppendingPathComponent:outputFileAudioRenamed];
            
            NSLog(@"%@", outputAudioFileURL);
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self.appController convertVideoToAudioWithInputURL:inputVideoURL outputURL:outputAudioFileURL handler:^(AVAssetExportSession *assetExportSession) {
                    
                    NSLog(@"Video successfull converted.");
                    
                }];
            });
            
        }
        
    } cancelBlock:^{
        
        NSLog(@"User cancel save panel.");
        
    }];
     */
}
@end
