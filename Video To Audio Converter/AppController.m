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

// Fix - name of method - put a N
// Fix - path with tab in the name
- (void)showOpenDialogWithMultipleSelectio:(BOOL)allowMultipleSelectio successBlock:(void (^)(NSArray<NSURL *> * urlsList))success cancelBlock:(void(^)())cancel
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
            
            NSLog(@"URL returned from dialog: %@", openFilesPathURL);
            
            NSString *s=[[openPanel URL] path];
            
            NSLog(@"path to file: %@", s);
            
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
                
                //NSLog(@"Done");
                
                break;
            }
                
            case AVAssetExportSessionStatusCancelled: {
                
                //NSLog(@"Cancel");
                
                break;
            }
                
            case AVAssetExportSessionStatusFailed:{
            
                //NSLog(@"Failed");
                
                break;
             
            }
                
            case AVAssetExportSessionStatusUnknown:{

                //NSLog(@"Unknown");
                
                break;
            }
                
            case AVAssetExportSessionStatusWaiting:{
                
                //NSLog(@"Wating");
                
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

- (IBAction)convertButton:(id)sender {
    
    [self showOpenDialogWithMultipleSelectio:NO successBlock:^(NSArray<NSURL *> *urlsList) {
        
         self.destinationFolder = urlsList[0];
         
         for (__block MediaFile *media in self.mediaFilesList) {
             
             if (media.checked){
             
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 //dispatch_sync(dispatch_get_main_queue(), ^{
                 
                     @try {
                     
                         NSURL *outputURL = [FileObject makeOutputURLWithPath:[self.destinationFolder absoluteString] andFileName:media.name andExtension:@"m4a"];
                         
                         NSLog(@"Created output path: %@", outputURL);
                         
                         if ([FileObject checkIfFileAlreadyExistsWithPath:[outputURL absoluteString]]){
                             
                             media.status = @"File Already Exists";
                             
                             [self updateArrayControllers];
                             
                             return;
                         }
                         
                         [self convertVideoToAudioWithInputURL:media.fileObject.fileURL outputURL:outputURL handler:^(AVAssetExportSession *assetExportSession) {
                         
                             NSLog(@"assetExportSession: %ld", (long)assetExportSession.status);
                             
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
                             
                             //[self updateArrayControllers];
                        }];
                         
                     } @catch (NSException *exception) {
                         
                         media.status = @"Failed";
                         
                     } @finally {
                         
                         //[self updateArrayControllers];
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

/*
 - (NSURL *)showSaveDialog(void (^)(NSURL * url))urlBlock
 {
 NSSavePanel *savePanel = [NSSavePanel savePanel];
 
 [savePanel setCanCreateDirectories:YES];
 
 [savePanel setCanSelectHiddenExtension:NO];
 
 __block NSURL *saveFilePathURL = nil;
 
 [savePanel beginSheetModalForWindow:self.appDelegate.window completionHandler:^(NSInteger result) {
 
 if (result == NSFileHandlingPanelOKButton) {
 
 saveFilePathURL = [savePanel URL];
 
 urlBlock(saveFilePathURL);
 
 }
 }];
 }
 
 */

@end
