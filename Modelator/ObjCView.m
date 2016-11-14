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
@property (weak) IBOutlet NSButton *checkCopy;

@end

@implementation ObjCView

- (void)awakeFromNib {
    [super awakeFromNib];
    ((NSTextField *)self.cmbType).delegate = self;
}

- (ObjcPropertySettings *)settings {
    ModelatorProperty *prop = (ModelatorProperty *)self.assocciatedProperty;
    ObjcPropertySettings *settings = (ObjcPropertySettings *)prop.propertySettings;
    return settings;
}

- (IBAction)nonAtomicClicked:(id)sender {
    [self settings].nonAtomicProperty = self.checkNonatomic.state;
}

- (IBAction)readOnlyClicked:(id)sender {
    [self settings].readOnlyProperty = self.checkReadonly.state;
}

- (IBAction)copyClicked:(id)sender {
    [self settings].copyProperty = self.checkCopy.state;
}

- (IBAction)strongWeakClicked:(id)sender {
    [self settings].weakProperty = self.radioWeak.state;
}
- (void)associatedPropertyChanged {
    ModelatorProperty *prop = (ModelatorProperty *)self.assocciatedProperty;
    ObjcPropertySettings *settings = (ObjcPropertySettings *)prop.propertySettings;
    
    self.checkCopy.state = settings.copyProperty;
    self.checkNonatomic.state = settings.nonAtomicProperty;
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
}
- (void)controlTextDidChange:(NSNotification *)obj {
    ((ModelatorProperty *)self.assocciatedProperty).propertyType = self.cmbType.stringValue;
}
//- (NSUInteger)comboBox:(NSComboBox *)comboBox indexOfItemWithStringValue:(NSString *)string {
//    return [[self settings].propertyTypes indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSRange range = NSMakeRange(0, [string length]);
//        return [string isEqualToString:[obj substringWithRange:range]];
//    }];
//}
@end
