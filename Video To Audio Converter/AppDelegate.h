//
//  AppDelegate.h
//  Video To Audio Converter
//
//  Created by Raphael Fontenelle on 02/08/16.
//  Copyright © 2016 Raphael Fontenelle. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (weak) IBOutlet NSWindow *mainWindow;

@property (weak) IBOutlet NSWindow *mediaWindow;

+ (AppDelegate *)sharedAppDelegate;


@end

