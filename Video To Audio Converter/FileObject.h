//
//  FileObject.h
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 03/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject


/**
 *  Property used if the file is a directory.
 */
@property (nonatomic, assign) BOOL isDirectory;

/**
 *  Property to be used if the user checks the file.
 */
@property (nonatomic, assign) BOOL checked;

/**
 *  Property of file URL.
 */
@property (nonatomic, strong) NSURL *fileURL;

/**
 *  Property that holds the file path in a NSString format.
 */
@property (nonatomic, copy) NSString *fileString;

/**
 *  File creation date.
 */
@property (nonatomic, strong) NSDate *creationDate;

/**
 *  File modification date.
 */
@property (nonatomic, strong) NSDate *modificationDate;

/**
 *  Initialization method used to create an instance of FileObject.
 *
 *  @param fileURL File URL path to the file
 *
 *  @return FileObject instance
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL;

/**
 *  Initialization method used to create an instance of FileObject
 *
 *  @param fileString NSString that contains the path to the file.
 *
 *  @return FileObject instance
 */
- (instancetype)initWithFileString:(NSString *)fileString;

/**
 *  Returns a NSURL composed of directory, file name and extension
 *
 *  @param directoryPath Output directory path.
 *  @param fileName      File name.
 *  @param extension     File extension.
 *
 *  @return NSURL with path composed of directory, file name and extension.
 */
+ (NSURL *)makeOutputURLWithPath:(NSString *)directoryPath andFileName:(NSString *)fileName andExtension:(NSString *)extension;

/**
 *  Check if file already exists in the given path.
 *
 *  @param filePath Path to file.
 *
 *  @return Boolean indicating if files exists.
 */
+ (BOOL)checkIfFileAlreadyExistsWithPath:(NSString *)filePath;

@end
