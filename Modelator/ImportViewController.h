//
//  ImportViewController.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ImportViewControllerDelegate <NSObject>

-(void)importViewControllerDidConfirmSelectionWithModuleIndex:(NSInteger)moduleIndex;

@end

@interface ImportViewController : NSViewController

@property (nonatomic, weak) id<ImportViewControllerDelegate>delegate;

@end
