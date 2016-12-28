//
//  ImportViewController.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ImportViewController.h"
#import "ModuleManager.h"

@interface ImportViewController ()
@property (weak) IBOutlet NSPopUpButton *popupLanguage;
@property (weak) IBOutlet NSPopUpButton *popupProtocol;

@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.popupLanguage removeAllItems];
    [self.popupLanguage addItemsWithTitles:[[ModuleManager sharedManager] moduleNames]];
    
    [self.popupProtocol removeAllItems];
    [self.popupProtocol addItemsWithTitles:@[@"No protocol"]];

}

- (void)ok:(id)sender {
    [self.delegate importViewControllerDidConfirmSelectionWithModuleIndex:self.popupLanguage.indexOfSelectedItem];
}


@end
