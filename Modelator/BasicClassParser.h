//
//  BasicClassParser.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 Kostantinos Aggelopoulos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelatorClass.h"
#import "ModelatorProperty.h"

@interface BasicClassParser : NSObject

@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, strong) NSArray<ModelatorClass *> *classes;


- (instancetype)initWithJSON:(id)json rootClassName:(NSString *)rootClassName;

@end
