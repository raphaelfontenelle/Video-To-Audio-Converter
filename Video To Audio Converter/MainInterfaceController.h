//
//  MainInterfaceController.h
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 02/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Cocoa;

@interface MainInterfaceController : NSObject;

// <NSTableViewDataSource, NSTableViewDelegate>


/**
 *  Return a singleton of the class MainInterfaceController. This class is responsible for controll the main window.
 *
 *  @return MainInterfaceController
 */
+ (MainInterfaceController *)sharedMainInterfaceController;

- (IBAction)convertVideoToAudioButton:(id)sender;

@end
