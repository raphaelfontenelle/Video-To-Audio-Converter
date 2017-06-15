//
//  MediaFiles.m
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 03/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import "MediaFile.h"

@implementation MediaFile

- (instancetype)init
{
    self = [super init];
    
    if (self){
        
        
    }
    return self;
}

- (instancetype)initWithFileObject:(FileObject *)fileObject
{
    self = [self init];
    
    if (self){
        
        self.fileObject = fileObject;
        
        NSString *fileName = [fileObject.fileString lastPathComponent];
        
        NSString *fileExtension = [fileName pathExtension];
        
        self.name = [fileName stringByDeletingPathExtension];
        
        self.extension = fileExtension;
        
    }
    return self;
}

@end
