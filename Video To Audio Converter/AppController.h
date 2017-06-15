//
//  AppController.h
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 02/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"
#import "MediaFile.h"

@import AVKit;
@import AVFoundation;


@interface AppController : NSObject


#pragma mark - Model Object

/**
 *  List containing all the files to be converted to audio.
 *<FileObject *>
 */

@property (nonatomic, strong) NSMutableArray *fileObjectList;

/**
 *  Array controller for fileObject.
 */
@property (weak) IBOutlet NSArrayController *fileObjectArrayController;

/**
 *  List of all video files to be converted.
 * <MediaFile *>
 */
@property (nonatomic, strong) NSMutableArray *mediaFilesList;

/**
 *  Array controller for media files list.
 */
@property (weak) IBOutlet NSArrayController *mediaObjectArrayController;

/**
 *  List of all audio files converted.
 *<MediaFile *>
 */
@property (nonatomic, strong) NSMutableArray *audioFilesList;

/**
 *  Array controlller for audio list.
 */
@property (weak) IBOutlet NSArrayController *audioObjectArrayController;


/**
 *  Property that holds the destination folder to save audio files.
 */
@property (nonatomic, strong) NSURL *destinationFolder;

#pragma marks -
/**
 *  Singleton used to share AppController.
 *
 *  @return AppController singleton.
 */
+ (AppController *)sharedAppController;

/**
 *  Shows open dialog for user choose the files he want's to convert and to choose the
 *  directory to save converted files.
 *
 *  @param successBlock Executed when user press OK button in the open dialog window
 *  @param cancelBlock  Execeuted when user press Cancel button in the dialog window
 */
- (void)showOpenDialogWithMultipleSelectio:(BOOL)allowMultipleSelectio successBlock:(void (^)(NSArray<NSURL *> * urlsList))success cancelBlock:(void(^)())cancel;

/**
 *  Convert video to audio.
 *
 *  @param inputURL  Input URL file path.
 *  @param outputURL Output URL file path.
 *  @param handler   Handler called when the work is done.
 */
- (void)convertVideoToAudioWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL
                                handler:(void (^)(AVAssetExportSession *assetExportSession))handler;

/**
 *  Update file Objects.
 */
- (void)updateFileObjects;

/**
 *  Update or rearrange arrays controllers.
 */
- (void)updateArrayControllers;


- (IBAction)selectAllButton:(id)sender;

- (IBAction)convertButton:(id)sender;



@end

/**
 *  Open save dialog painel and returns the path in URL format.
 *
 *  @return URL with the path to save the file.
 */
//- (NSURL *)showSaveDialog;

