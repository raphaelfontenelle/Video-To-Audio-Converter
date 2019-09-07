//
//  AppController.m
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 02/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import "AppController.h"
#import "AppDelegate.h"

@import AVKit;
@import AVFoundation;


@interface AppController()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end


@implementation AppController

/**
 *  Static variable used to keep the reference of AppController in the memory.
 */
static AppController *_singletonAppController;

@synthesize fileObjectList = _fileObjectList;

@synthesize mediaFilesList = _mediaFilesList;

@synthesize audioFilesList = _audioFilesList;

+ (AppController *)sharedAppController
{
    if (!_singletonAppController){
        
        _singletonAppController = [[AppController alloc] init];
    }
    
    return _singletonAppController;
}

- (instancetype)init
{
    if (!_singletonAppController){
        
        _singletonAppController = [super init];
        
        //Init code goes here.
        
        self.appDelegate = [AppDelegate sharedAppDelegate];
    }
    
    return _singletonAppController;
}

- (void)showOpenDialogWithMultipleSelection:(BOOL)allowMultipleSelectio successBlock:(void (^)(NSArray<NSURL *> * urlsList))success cancelBlock:(void(^)())cancel
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    [openPanel setCanChooseFiles:NO];
    
    if (allowMultipleSelectio){
        
        [openPanel setAllowsMultipleSelection:YES];
        
    } else {
        
        [openPanel setAllowsMultipleSelection:NO];
    }
    
    [openPanel setCanChooseDirectories:YES];
    
    __block NSArray<NSURL *> *openFilesPathURL = nil;
    
    [openPanel beginSheetModalForWindow:[[AppDelegate sharedAppDelegate] mainWindow] completionHandler:^(NSInteger result){
        
        if (result == NSFileHandlingPanelOKButton) {
            
            openFilesPathURL = [openPanel URLs];
            
            NSString *pathToFile=[[openPanel URL] path];
            
            NSMutableArray *openFilesPathURL = [NSMutableArray arrayWithObject:pathToFile];
            
            success(openFilesPathURL);
            
        } else if (result == NSFileHandlingPanelCancelButton) {
            
            cancel();
            
        }
    }];
}


- (void)convertVideoToAudioWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL
                                handler:(void (^)(AVAssetExportSession *assetExportSession))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset: asset
                                                                           presetName: AVAssetExportPresetPassthrough];
    exportSession.outputURL = outputURL;
    
    exportSession.outputFileType = AVFileTypeAppleM4A;
    
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        switch (exportSession.status) {
                
            case AVAssetWriterStatusCompleted:{
           
                break;
            }
                
            case AVAssetExportSessionStatusCancelled: {
                
                break;
            }
                
            case AVAssetExportSessionStatusFailed:{
            
                break;
             
            }
                
            case AVAssetExportSessionStatusUnknown:{

                break;
            }
                
            case AVAssetExportSessionStatusWaiting:{
                
                break;
            }
            default:{
                
                break;
            }
        }
        
        handler(exportSession);
    }];
}

- (void)updateFileObjects
{
    NSMutableArray *mediaList = [[NSMutableArray alloc] init];
    
    for (FileObject *fileObject in self.fileObjectList){
        
        MediaFile *mediaFile = [[MediaFile alloc] initWithFileObject:fileObject];
        
        [mediaList addObject:mediaFile];
    
    }
    
    self.mediaFilesList = mediaList;
    
    [self updateArrayControllers];

}

- (void)updateArrayControllers
{
    [self.fileObjectArrayController rearrangeObjects];
    
    [self.mediaObjectArrayController rearrangeObjects];
    
    [self.audioObjectArrayController rearrangeObjects];
}

#pragma mark - Main Button methods.

- (IBAction)selectAllButton:(id)sender {
    
    for (MediaFile *media in self.mediaFilesList) {
        
        media.checked = true;
    }
}

- (IBAction)clearAllButton:(id)sender{
    
    for (MediaFile *media in self.mediaFilesList) {
        
        media.checked = false;
    }
    
}

- (IBAction)convertButton:(id)sender {
    
    [self showOpenDialogWithMultipleSelection:NO successBlock:^(NSArray<NSURL *> *urlsList) {
        
         self.destinationFolder = urlsList[0];
         
         for (__block MediaFile *media in self.mediaFilesList) {
             
             if (media.checked){
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
                     @try {
                         
                         NSURL *outputURL = [FileObject makeOutputURLWithPath:self.destinationFolder andFileName:media.name andExtension:@"mp4"];
                        
                         if ([FileObject checkIfFileAlreadyExistsWithPath:[outputURL absoluteString]]){
                             
                             media.status = @"File Already Exists";
                             
                             [self updateArrayControllers];
                             
                             return;
                         }
                         
                         [self convertVideoToAudioWithInputURL:media.fileObject.fileURL outputURL:outputURL handler:^(AVAssetExportSession *assetExportSession) {
                         
                            switch (assetExportSession.status) {
                                   
                                     
                                case AVAssetExportSessionStatusUnknown: {
                                    
                                    media.status = @"Unknown";
                                    
                                    break;
                                 }
                                     
                                case AVAssetExportSessionStatusWaiting: {
                                    
                                    media.status = @"Wating";
                                    
                                    break;
                                 }
                                    
                                case AVAssetExportSessionStatusExporting: {
                                    
                                     break;
                                 }
                                    
                                case AVAssetExportSessionStatusCompleted: {
                                    
                                    media.status = @"Done";
                                    
                                    break;
                                 }
                                    
                                case AVAssetExportSessionStatusFailed: {
                                    
                                    media.status = @"Failed";
                                    
                                    break;
                                 }
                                    
                                case AVAssetExportSessionStatusCancelled: {
                                    
                                    media.status = @"Cancel";
                                    
                                    break;
                                 }
                               
                                default:{
                                     
                                     break;
                                 }
                             }
                        }];
                         
                     } @catch (NSException *exception) {
                         
                         media.status = @"Failed";
                         
                     } @finally {
                        
                     }
                     
                 });
             }
         }
        
    } cancelBlock:^{
        
    }];
}

#pragma marks - Getter and Setter methods

- (NSMutableArray *)fileObjectList
{
    if (!_fileObjectList){
        
        _fileObjectList = [[NSMutableArray alloc] init];

    }
    return _fileObjectList;
}

- (void)setFileObjectList:(NSMutableArray *)fileObjectList
{
    if ( _fileObjectList != fileObjectList ) {
        
        _fileObjectList = [fileObjectList mutableCopy];
    }
}

- (NSMutableArray *)mediaFilesList
{
    if (!_mediaFilesList){
        
        _mediaFilesList = [[NSMutableArray alloc] init];
    }
    return _mediaFilesList;
}

- (void)setMediaFilesList:(NSMutableArray*)mediaFilesList
{
    if (_mediaFilesList != mediaFilesList){
        
        _mediaFilesList = [mediaFilesList mutableCopy];
    }
}

- (NSMutableArray<MediaFile *> *)audioFilesList
{
    if (!_audioFilesList){
        
        _audioFilesList = [[NSMutableArray alloc] init];
    }
    return _audioFilesList;
}

-(void)setAudioFilesList:(NSMutableArray<MediaFile *> *)audioFilesList
{
    if (_audioFilesList != audioFilesList){
        
        _audioFilesList = [audioFilesList mutableCopy];
    }
}

@end
