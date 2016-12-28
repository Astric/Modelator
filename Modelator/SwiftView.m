//
//  SwiftView.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 28/12/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "SwiftView.h"
#import "ModelatorProperty.h"
#import "SwiftPropertySettings.h"

@interface SwiftView ()<NSComboBoxDataSource, NSTextFieldDelegate>

@property (weak) IBOutlet NSComboBox *cmbType;
@property (weak) IBOutlet NSButton *radioStrong;
@property (weak) IBOutlet NSButton *radioWeak;
@property (weak) IBOutlet NSButton *checkNonatomic;
@property (weak) IBOutlet NSButton *checkReadonly;
@property (weak) IBOutlet NSButton *radioCopy;

@end

@implementation SwiftView

- (void)awakeFromNib {
    [super awakeFromNib];
    ((NSTextField *)self.cmbType).delegate = self;
    self.cmbType.numberOfVisibleItems = 10;
}

- (SwiftPropertySettings *)settings {
    ModelatorProperty *prop = (ModelatorProperty *)self.assocciatedProperty;
    SwiftPropertySettings *settings = (SwiftPropertySettings *)prop.propertySettings;
    return settings;
}


- (IBAction)somethingChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modelator.PropertyChangeNotification" object:nil];
}

- (void)associatedPropertyChanged {
    ModelatorProperty *prop = (ModelatorProperty *)self.assocciatedProperty;
    SwiftPropertySettings *settings = (SwiftPropertySettings *)prop.propertySettings;
    
    self.radioCopy.state = settings.copyProperty;
    self.radioWeak.state = settings.weakProperty;
    self.radioStrong.state = settings.strongProperty;
    
    self.checkNonatomic.state = settings.atomicProperty;
    self.checkReadonly.state = settings.readOnlyProperty;
    
    [self.cmbType reloadData];
    self.cmbType.stringValue =  ((ModelatorProperty *)self.assocciatedProperty).propertyType;
}
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    return [[self settings].propertyTypes count];
}
- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    return [self settings].propertyTypes[index];
}
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    ((ModelatorProperty *)self.assocciatedProperty).propertyType = [self settings].propertyTypes[[self.cmbType indexOfSelectedItem]];
    [self somethingChanged];
}
- (void)controlTextDidChange:(NSNotification *)obj {
    ((ModelatorProperty *)self.assocciatedProperty).propertyType = self.cmbType.stringValue;
    [self somethingChanged];
}
//- (NSUInteger)comboBox:(NSComboBox *)comboBox indexOfItemWithStringValue:(NSString *)string {
//    return [[self settings].propertyTypes indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSRange range = NSMakeRange(0, [string length]);
//        return [string isEqualToString:[obj substringWithRange:range]];
//    }];
//}
@end
