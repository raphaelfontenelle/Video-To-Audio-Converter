//
//  FileObject.m
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 03/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import "FileObject.h"

@implementation FileObject

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //Init code goes here for all object.
        
    }
    return self;
}

- (instancetype)initWithFileURL:(NSURL *)fileURL
{
    self = [self init];
    
    self.fileURL = fileURL;

    //NSString *extension = [fileURL pathExtension];
    
    return self;
}

- (instancetype)initWithFileString:(NSString *)fileString
{
    self = [self init];
    
    if (self) {
    
        self.fileURL = [[NSURL alloc] initFileURLWithPath:fileString];
    
        self.fileString = fileString;
    
        NSDictionary *attributesDictionary = [FileObject getFileAttributes:fileString];
    
        self.modificationDate = attributesDictionary[NSFileModificationDate];
        
        NSLog(@"modificationDate: %@", self.modificationDate);
        
        self.creationDate = attributesDictionary[NSFileCreationDate];
        
        NSLog(@"creationDate: %@", self.creationDate);
    
    }
    
    return self;
}

+ (NSURL *)makeOutputURLWithPath:(NSString *)directoryPath andFileName:(NSString *)fileName andExtension:(NSString *)extension
{
    NSString *dirPath = [directoryPath stringByReplacingOccurrencesOfString:@"file:/" withString:@""];
    
    NSString *outputPath = [dirPath stringByAppendingPathComponent:fileName];
    
    NSString *outputPathWithExtension = [outputPath stringByAppendingPathExtension:extension];
    
    NSURL *outputURL = [NSURL fileURLWithPath:outputPathWithExtension];
    
    return outputURL;
}

+ (NSDictionary *)getFileAttributes:(NSString *)filePath
{
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    if (error){
        
        NSLog(@"%@", error.localizedDescription);
        
        return nil;
    }

    return fileAttributes;
}

+ (BOOL)checkIfFileAlreadyExistsWithPath:(NSString *)filePath
{
    NSString *fileNamePath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[fileNamePath stringByRemovingPercentEncoding]];
}


//Not finished need to create a file with next integer
+ (NSURL *)createFileName:(NSURL *)fileURL
{
    NSString* fileNameWithExtension = fileURL.lastPathComponent;
    
    NSString* fileName = [fileNameWithExtension stringByDeletingPathExtension];
    
    NSString* extension = fileNameWithExtension.pathExtension;
   
    for (int i = 0; i < 100; i++){
       
        if ([FileObject checkIfFileAlreadyExistsWithPath:[fileURL absoluteString]]) {
         
            fileName = [NSString stringWithFormat:@"fileName-%i", i];
            
        } else {
            
            break;
        }
    }
    
    return nil;
}

@end
