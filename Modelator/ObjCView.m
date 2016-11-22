//
//  ObjCView.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 13/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ObjCView.h"
#import "ModelatorProperty.h"
#import "ObjcPropertySettings.h"

@interface ObjCView ()<NSComboBoxDataSource, NSTextFieldDelegate>

@property (weak) IBOutlet NSComboBox *cmbType;
@property (weak) IBOutlet NSButton *radioStrong;
@property (weak) IBOutlet NSButton *radioWeak;
@property (weak) IBOutlet NSButton *checkNonatomic;
@property (weak) IBOutlet NSButton *checkReadonly;
@property (weak) IBOutlet NSButton *radioCopy;

@end

@implementation ObjCView

- (void)awakeFromNib {
    [super awakeFromNib];
    ((NSTextField *)self.cmbType).delegate = self;
    self.cmbType.numberOfVisibleItems = 10;
}

- (ObjcPropertySettings *)settings {
    ModelatorProperty *prop = (ModelatorProperty *)self.assocciatedProperty;
    ObjcPropertySettings *settings = (ObjcPropertySettings *)prop.propertySettings;
    return settings;
}

- (IBAction)atomicClicked:(id)sender {
    [self settings].atomicProperty = self.checkNonatomic.state;
    [self somethingChanged];
}

- (IBAction)readOnlyClicked:(id)sender {
    [self settings].readOnlyProperty = self.checkReadonly.state;
    [self somethingChanged];
}

- (IBAction)radioClicked:(id)sender {
    [self settings].weakProperty = self.radioWeak.state;
    [self settings].strongProperty = self.radioStrong.state;
    [self settings].copyProperty = self.radioCopy.state;
    [self somethingChanged];
}

- (IBAction)somethingChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modelator.PropertyChangeNotification" object:nil];
}

- (void)associatedPropertyChanged {
    ModelatorProperty *prop = (ModelatorProperty *)self.assocciatedProperty;
    ObjcPropertySettings *settings = (ObjcPropertySettings *)prop.propertySettings;
    
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
