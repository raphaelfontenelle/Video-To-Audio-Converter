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
        
        self.appController = [AppController sharedAppController];
    }
    
    return _singletonMainInterfaceController;
}

@end
