//
//  ObjcPropertySettings.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 13/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjcPropertySettings : NSObject

@property (nonatomic, assign) BOOL nonAtomicProperty;
@property (nonatomic, assign) BOOL assignProperty;
@property (nonatomic, assign) BOOL copyProperty;
@property (nonatomic, assign) BOOL weakProperty;
@property (nonatomic, assign) BOOL strongProperty;
@property (nonatomic, assign) BOOL readOnlyProperty;

@end
