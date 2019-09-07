//
//  DragAndDropView.m
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 03/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import "DragAndDropView.h"
#import "AppController.h"
#import "FileObject.h"

@interface DragAndDropView()

@property (nonatomic, strong) AppController *appController;

@end


@implementation DragAndDropView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self){

        self.appController = [AppController sharedAppController];
        
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - Drag And Drop Methods.

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    NSArray<NSString *> *audioVisualUTIs = [AVURLAsset audiovisualTypes];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType] ) {
        
        if (sourceDragMask & NSDragOperationGeneric) {
            
            NSArray *filesPath = [pboard propertyListForType:NSFilenamesPboardType];
            
            for (NSString *file in filesPath) {
                
                NSString *lastPath = [file lastPathComponent];
                
                NSString *fileExtension = [lastPath pathExtension];
                
                //if ([audioVisualUTIs containsObject:fileExtension]){
                    
                
                //}
            }
            return NSDragOperationGeneric;
        }
    }
    return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType] ) {
        
        if (sourceDragMask & NSDragOperationGeneric) {
            
            return NSDragOperationGeneric;
        }
    }
    
    return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]){
        
        NSArray *filesPath = [pboard propertyListForType:NSFilenamesPboardType];
        
        for (NSString *file in filesPath) {
            
            FileObject *fileObject = [[FileObject alloc] initWithFileString:file];
            
            //if (![self.appController.fileObjectList containsObject:fileObject]){
                
                [self.appController.fileObjectList addObject:fileObject];
            
            
                
            //} else {
                
            //}
        }
        //Call the method that update arrays controlles
        [self.appController updateFileObjects];
    }
    return YES;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    
}


@end
