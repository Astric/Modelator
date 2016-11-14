//
//  PropertyView.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 14/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "PropertyView.h"

@implementation PropertyView

- (void)setAssocciatedProperty:(id)assocciatedProperty {
    _assocciatedProperty = assocciatedProperty;
    [self associatedPropertyChanged];
}

- (void)associatedPropertyChanged {
    NSLog(@"Override please");
}
@end
