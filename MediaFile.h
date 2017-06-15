//
//  MediaFiles.h
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 03/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"

@interface MediaFile : NSObject


/**
 *  Property that holds the name of the current media file.
 */
@property (nonatomic, copy) NSString *name;

/**
 *  Property that holds the extension of the media file.
 */
@property (nonatomic, copy) NSString *extension;

/**
 *  Property that holds the status of conversion.
 */
@property (nonatomic, copy) NSString *status;

/**
 *  Property used to check media file for convertion.
 */
@property (nonatomic, assign) BOOL checked;

/**
 *  File object related to the media file holding files properties.
 */
@property (nonatomic, strong) FileObject *fileObject;

/**
 *  Initializaton that create a instance of MediaFile based in a
 *  FileObject
 *
 *  @param fileObject FileObject instance.
 *
 *  @return MediaFile instance.
 */
- (instancetype)initWithFileObject:(FileObject *)fileObject;

@end
